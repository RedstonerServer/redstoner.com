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
end
