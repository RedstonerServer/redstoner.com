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

  def to_param
    [id, to_s.parameterize].join("-")
  end

  def self.filter (user, title, content, reply, label, author, query, forum)
  userid = user.try(:id).to_i
  role = user.try(:role).to_i

  can_read = "COALESCE(forum_role_read.value, 0) <= ? AND COALESCE(forumgroup_role_read.value, 0) <= ?"
  sticky_can_write = "sticky = true AND (COALESCE(forum_role_write.value, 0) <= ? OR COALESCE(forumgroup_role_write.value, 0) <= ?)"

  threads = forum.try(:forumthreads) || Forumthread
  threads = threads.where("forumthreads.user_author_id = ? OR (#{can_read}) OR (#{sticky_can_write})", userid, role, role, role, role)
  .joins("LEFT JOIN threadreplies ON forumthreads.id = threadreplies.forumthread_id")
  .joins(forum: :forumgroup)
  .joins("LEFT JOIN roles as forum_role_read ON forums.role_read_id = forum_role_read.id")
  .joins("LEFT JOIN roles as forum_role_write ON forums.role_write_id = forum_role_write.id")
  .joins("LEFT JOIN roles as forumgroup_role_read ON forumgroups.role_read_id = forumgroup_role_read.id")
  .joins("LEFT JOIN roles as forumgroup_role_write ON forumgroups.role_write_id = forumgroup_role_write.id")

  if [content, title, reply, label, author, query].any?
    label_o = Label.find_by(name: label)
    if label_o
      threads = threads.where(label: label_o)
    elsif label.try(:downcase) == "no label"
      threads = threads.where(label: nil)
    end

    threads = threads.where(user_author: author) if author

    if query
      threads = threads.where("MATCH (title, forumthreads.content) AGAINST (?) OR MATCH (threadreplies.content) AGAINST (?)", query, query)
    elsif [title, content, reply].any?
      query = [title, content, reply].select(&:present?).join(" ")
      threads = threads.where("MATCH (title) AGAINST (?)", title) if title
      threads = threads.where("MATCH (forumthreads.content) AGAINST (?)", content) if content
      threads = threads.where("MATCH (threadreplies.content) AGAINST (?)", reply) if reply
      threads = threads.group("threadreplies.id", "forumthreads.id")
      threads = threads.order("(MATCH (title, forumthreads.content) AGAINST ('#{query}')) DESC")
    end
  end

  threads = threads.order("sticky desc", "threadreplies.created_at desc", "forumthreads.created_at desc") if threads.order_values.empty?

    threads
  end
end
