class Message < ActiveRecord::Base

  include MailerHelper

  belongs_to :user_sender, class_name: "User", foreign_key: "user_sender_id"
  belongs_to :user_target, class_name: "User", foreign_key: "user_target_id"
  belongs_to :user_editor, class_name: "User", foreign_key: "user_editor_id"
  belongs_to :user_hidden, class_name: "User", foreign_key: "user_hidden_id"
  belongs_to :user_unread, class_name: "User", foreign_key: "user_unread_id"


  validates_presence_of :user_sender, :user_target, :text, :subject

  validates_length_of :text, in: 1..8000
  validates_length_of :subject, in: 1..2000

  has_many :messagereplies

  accepts_nested_attributes_for :messagereplies

  before_destroy :do_destroy?

  def do_destroy?
    if user_hidden || user_sender == user_target
      return true
    else
      update_attributes(user_hidden: User.current)
      return false
    end
  end

  def to_s
    subject
  end

  def sender
    @sender ||= if self.user_sender.present?
      user_sender
    else
      User.first
    end
  end

  def target
    @target ||= if self.user_target.present?
      user_target
    else
      User.first
    end
  end

  def editor
    @editor ||= (self.user_editor || User.first)
  end

  def edited?
    !!user_editor_id
  end

  def replies
    messagereplies
  end

  def send_new_message_mail
    begin
      mail = RedstonerMailer.new_message_mail(user_target, self)
    rescue => e
      Rails.logger.error "---"
      Rails.logger.error "WARNING: Failed to create new_message_mail (view) for message#: #{@message.id}, user: #{@user.name}, #{@user.email}"
      Rails.logger.error e.message
      Rails.logger.error "---"
    end
    background_mailer([mail])
  end
end
