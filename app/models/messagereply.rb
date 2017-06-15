class Messagereply < ActiveRecord::Base

  include MailerHelper
  include UsersHelper

  belongs_to :message
  belongs_to :user_author, class_name: "User", foreign_key: "user_author_id"
  belongs_to :user_editor, class_name: "User", foreign_key: "user_editor_id"



  validates_presence_of :text
  validates_length_of :text, in: 1..8000

  def get_message
    message
  end

  def author
    @author ||= if self.user_author.present?
      user_author
    else
      User.first
    end
  end

  def editor
    # can be nil
    @editor ||= user_editor
  end

  def edited?
    !!user_editor_id
  end

  def send_new_reply_mail(old_content = "")
    users = mentions(content) - mentions(old_content)

    # thread + replies
    posts = message.replies.to_a
    posts << message if message.author.mail_own_message_reply?
    # only send "reply" mail when reply is new
    unless old_content.present?
      posts.each do |post|
        # don't send mail to the author of this reply, don't send to banned/disabled users
        if post.author != author && post.author.normal? && post.author.confirmed? # &&
          users << post.author if post.author.mail_other_thread_reply?
        end
      end
    end
    # making sure we don't send multiple mails to the same user
    users.uniq!

    mails = []
    users.each do |usr|
      begin
        mails << RedstonerMailer.new_thread_reply_mail(usr, self)
      rescue => e
        Rails.logger.error "---"
        Rails.logger.error "WARNING: Failed to create new_thread_reply_mail (view) for reply#: #{@self.id}, user: #{@user.name}, #{@user.email}"
        Rails.logger.error e.message
        Rails.logger.error "---"
      end
    end
    background_mailer(mails)
  end
end
