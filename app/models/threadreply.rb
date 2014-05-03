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
    posts = thread.replies.to_a
    posts << thread # if thread.author.send_own_thread_reply_mail (TODO)
    posts.each do |post|
      # don't send mail to the author, don't send to banned/disabled users
      if post.author != author && post.author.normal? && post.author.confirmed? # &&
        userids << post.author.id # && post.author.send_replied_reply_mail (TODO)
      end
    end
    # making sure we don't send multiple mails to the same user
    userids.uniq!

    mails = []
    userids.each do |uid|
      begin
        mails << RedstonerMailer.new_thread_reply_mail(User.find(uid), self)
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