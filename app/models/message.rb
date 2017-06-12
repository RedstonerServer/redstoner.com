class Message < ActiveRecord::Base

  include MailerHelper

  belongs_to :user_sender, class_name: "User", foreign_key: "user_sender_id"
  belongs_to :user_target, class_name: "User", foreign_key: "user_target_id"

  validates_presence_of :user_sender, :user_target, :text, on: :create

  validates_length_of :text, in: 1..8000

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
