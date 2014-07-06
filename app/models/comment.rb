class Comment < ActiveRecord::Base

  include MailerHelper
  include UsersHelper

  belongs_to :user_author, class_name: "User", foreign_key: "user_author_id"
  belongs_to :user_editor, class_name: "User", foreign_key: "user_editor_id"

  validates_presence_of :content, :author, :blogpost
  validates_length_of :content, in: 4..1000

  belongs_to :blogpost
  belongs_to :user_author, class_name: "User", foreign_key: "user_author_id"

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

  def send_new_comment_mail
    userids = []

    # post + comments
    comments = blogpost.comments.to_a
    comments << blogpost if blogpost.author.mail_own_blogpost_comment?
    comments.each do |comment|
      # don't send mail to the author of this comment, don't send to banned/disabled users
      if comment.author != author && comment.author.normal? && comment.author.confirmed? # &&
        userids << comment.author.id if comment.author.mail_other_blogpost_comment?
      end
    end
    # making sure we don't send multiple mails to the same user
    userids.uniq!

    mails = []
    userids.each do |uid|
      begin
        mails << RedstonerMailer.new_post_comment_mail(User.find(uid), self)
      rescue => e
        Rails.logger.error "---"
        Rails.logger.error "WARNING: Failed to create post_reply mail (view) for reply#: #{@self.id}, user: #{@user.name}, #{@user.email}"
        Rails.logger.error e.message
        Rails.logger.error "---"
      end
    end
    background_mailer(mails)
  end

  def send_new_mention_mail(old_content = "")
    new_mentions = mentions(content) - mentions(old_content)
    mails = []
    new_mentions.each do |user|
      begin
        mails << RedstonerMailer.new_post_comment_mention_mail(user, self) if user.normal? && user.confirmed? && user.mail_mention?
      rescue => e
        Rails.logger.error "---"
        Rails.logger.error "WARNING: Failed to create new_post_comment_mention_mail (view) for reply#: #{@self.id}, user: #{@user.name}, #{@user.email}"
        Rails.logger.error e.message
        Rails.logger.error "---"
      end
    end
    background_mailer(mails)
  end
end