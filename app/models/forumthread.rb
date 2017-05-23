class Forumthread < ActiveRecord::Base

  include MailerHelper
  include UsersHelper

  belongs_to :forum
  belongs_to :user_author, class_name: "User", foreign_key: "user_author_id"
  belongs_to :user_editor, class_name: "User", foreign_key: "user_editor_id"
  belongs_to :label
  has_many   :threadreplies

  validates_presence_of :title, :author, :forum
  validates_presence_of :content
  validates_length_of :content, in: 5..20000

  accepts_nested_attributes_for :threadreplies

  def to_s
    title
  end

  def author
    @author ||= (user_author || User.first)
  end

  def editor
    @editor ||= (self.user_editor || User.first)
  end

  def edited?
    !!user_editor_id
  end

  def replies
    threadreplies
  end

  def can_read?(user)
    # we might have threads without a forum
    # e.g. forum deleted
    forum && (forum.can_read?(user) || (forum.can_write?(user) && self.sticky?) || author == user)
  end

  def can_write?(user)
    # unlike forums, you shouldn't be able to write when you can't read
    can_read?(user) && forum.can_write?(user) && (!locked? || user.mod?)
  end

  def send_new_mention_mail(old_content = "")
    new_mentions = mentions(content) - mentions(old_content)
    mails = []
    new_mentions.each do |user|
      begin
        mails << RedstonerMailer.new_thread_mention_mail(user, self) if user.normal? && user.confirmed? && self.can_read?(user) && user.mail_mention?
      rescue => e
        Rails.logger.error "---"
        Rails.logger.error "WARNING: Failed to create new_thread_mention_mail (view) for reply#: #{@self.id}, user: #{@user.name}, #{@user.email}"
        Rails.logger.error e.message
        Rails.logger.error "---"
      end
    end
    background_mailer(mails)
  end

  def self.display_threads (current_user, params, flash)

    if params[:content] || params[:title] || params[:reply] || params[:label] || params[:author] || params[:query]

      if params[:id] == nil
        @threads = Forumthread.where("forumthreads.user_author_id = ? OR COALESCE(roles.value, 0) <= ?", current_user.try(:id).to_i, current_user.try(:role).to_i)
        .joins("LEFT JOIN threadreplies ON forumthreads.id = threadreplies.forumthread_id")
        .joins(forum: :forumgroup).joins("LEFT JOIN roles ON forums.role_read_id = roles.id")
      else
        @threads = Forumthread.where(forum_id: params[:id]).where("forumthreads.user_author_id = ? OR COALESCE(roles.value, 0) <= ?", current_user.try(:id).to_i, current_user.try(:role).to_i).joins("LEFT JOIN threadreplies ON forumthreads.id = threadreplies.forumthread_id")
        .joins(forum: :forumgroup).joins("LEFT JOIN roles ON forums.role_read_id = roles.id")
      end

      if params[:query]
        etotal = params[:query]
        @threads = @threads.where("MATCH (title, forumthreads.content) AGAINST (?) OR MATCH (threadreplies.content) AGAINST (?)", params[:query], params[:query])
      else
        etotal = [params[:title].to_s, params[:content].to_s].reject(&:empty?).join(' ')
        if params[:title]
          @threads = @threads.where("MATCH (title) AGAINST (?)", params[:title])
        end

        if params[:content]
        vv@threads = @threads.where("MATCH (forumthreads.content) AGAINST (?)", params[:content])
        end

        if params[:reply]
          @threads = @threads.where("MATCH (threadreplies.content) AGAINST (?)", params[:reply])
        end
      end

      label = Label.find_by(name: params[:label])
      if label
        @threads = @threads.where(label_id: label.id)
      elsif params[:label]
        if params[:label].downcase == "no label"
          @threads = @threads.where(label_id: nil)
        else
          flash[:alert] = "'#{params[:label]}' is not a valid label."
        end
      end

      if params[:author]
        authors = User.where("ign = ? OR name = ?", params[:author], params[:author])
        if authors.try(:count) > 0
          @threads = @threads.where(user_author: authors)
        else
          @threads = @threads.where(user_author: nil)
        end
      end

      if params[:title] || params[:content] || params[:reply]
        if @threads.size > 0
          @threads = @threads.group("threadreplies.id", "forumthreads.id").order("(MATCH (title, forumthreads.content) AGAINST ('#{etotal}')) DESC")
        end
      else
        @threads = @threads.order("sticky desc", "COALESCE(threadreplies.created_at, forumthreads.created_at) desc")
      end
    else
      if params[:id] == nil
        @threads = Forumthread.where("forumthreads.user_author_id = ? OR COALESCE(roles.value, 0) <= ?", current_user.try(:id).to_i, current_user.try(:role).to_i)
        .joins(forum: :forumgroup).joins("LEFT JOIN roles ON forums.role_read_id = roles.id")
      else
        @threads = Forum.find(params[:id]).forumthreads.where("forumthreads.user_author_id = ? OR COALESCE(roles.value, 0) <= ?", current_user.try(:id).to_i, current_user.try(:role).to_i)
        .joins(forum: :forumgroup).joins("LEFT JOIN roles ON forums.role_read_id = roles.id")
      end
      @threads = @threads.joins("LEFT JOIN threadreplies ON forumthreads.id = threadreplies.forumthread_id").order("sticky desc", "COALESCE(threadreplies.created_at, forumthreads.created_at) desc")
    end
    @threads = @threads.page(params[:page]).per(30)
    return @threads.uniq
  end
end
