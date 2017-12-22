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
  validates_length_of :title, in: 5..255
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
    order_phrase = query || [title, content, reply].select(&:present?).join(" ")
    user_id = user.try(:id).to_i
    role_value = user.try(:role).to_i
    can_read = "COALESCE(forum_role_read.value, 0) <= ? AND COALESCE(forumgroup_role_read.value, 0) <= ?"
    # A user can view sticky threads in write-only forums without read permissions.
    sticky_can_write = "sticky = true AND (COALESCE(forum_role_write.value, 0) <= ? AND COALESCE(forumgroup_role_write.value, 0) <= ?)"
    match = ["MATCH (title, forumthreads.content) AGAINST (#{Forumthread.sanitize(order_phrase)})", "MATCH (threadreplies.content) AGAINST (#{Forumthread.sanitize(order_phrase)})", "MATCH (title, forumthreads.content) AGAINST (?) OR MATCH (threadreplies.content) AGAINST (?)", "MATCH (title) AGAINST (?)", "MATCH (forumthreads.content) AGAINST (?)", "MATCH (threadreplies.content) AGAINST (?)"]

    threads = forum.try(:forumthreads) || Forumthread

    threads = threads.select("forumthreads.*", "#{match[0]} AS relevance", "#{match[1]} AS reply_rel")

    threads = threads.joins(forum: :forumgroup)
    .joins("LEFT JOIN threadreplies ON forumthreads.id = threadreplies.forumthread_id")
    .joins("LEFT JOIN roles as forum_role_read ON forums.role_read_id = forum_role_read.id")
    .joins("LEFT JOIN roles as forum_role_write ON forums.role_write_id = forum_role_write.id")
    .joins("LEFT JOIN roles as forumgroup_role_read ON forumgroups.role_read_id = forumgroup_role_read.id")
    .joins("LEFT JOIN roles as forumgroup_role_write ON forumgroups.role_write_id = forumgroup_role_write.id")

    threads = threads.where("forumthreads.user_author_id = ? OR (#{can_read}) OR (#{sticky_can_write}) OR (?)", user_id, role_value, role_value, role_value, role_value, Forum.find(forum).can_read?(user))
    if query
      threads = threads.where("#{match[2]}", query[0..99], query[0..99])
    elsif [title, content, reply].any?
      threads = threads.where("#{match[3]}", title[0..99]) if title
      threads = threads.where("#{match[4]}", content[0..99]) if content
      threads = threads.where("#{match[5]}", reply[0..99]) if reply
    end
    if label.try(:downcase) == "no label"
      threads = threads.where(label: nil)
    elsif label && l = Label.find_by(name: label)
      threads = threads.where(label: l)
    end
    threads = threads.where(user_author: author) if author

    threads = threads.group("forumthreads.id")

    if order_phrase.present?
      threads = threads.order("GREATEST(relevance, reply_rel) DESC")
    else
      threads = threads.order("sticky DESC", "threadreplies.id DESC", "forumthreads.id DESC")
    end
    threads
  end
end
