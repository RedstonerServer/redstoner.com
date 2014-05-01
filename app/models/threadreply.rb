class Threadreply < ActiveRecord::Base

  include MailerHelper

  belongs_to :forumthread
  belongs_to :user_author, class_name: "User", foreign_key: "user_author_id"
  belongs_to :user_editor, class_name: "User", foreign_key: "user_editor_id"



  validates_presence_of :content
  validates_length_of :content, in: 2..10000

  def thread
    forumthread
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

  def send_new_reply_mail
    userids = []

    # thread + replies
    (thread.replies.to_a << thread).each do |post|
      # don't send mail to the user who wrote this, don't send to banned/disabled users
      if post.author != author && post.author.normal? # && user.send_threadreply_mail (TODO)
        userids << post.author.id
      end
    end
    # making sure we don't send multiple mails to the same user
    userids.uniq!

    mails = []
    userids.each do |uid|
      begin
        mails << RedstonerMailer.thread_reply_mail(User.find(uid), self)
      rescue => e
        Rails.logger.error "---"
        Rails.logger.error "WARNING: Failed to create thread_reply mail (view) for reply#: #{@self.id}, user: #{@user.name}, #{@user.email}"
        Rails.logger.error e.message
        Rails.logger.error "---"
      end
    end
    background_mailer(mails)
  end
end