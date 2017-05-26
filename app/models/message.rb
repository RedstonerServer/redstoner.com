class Message < ActiveRecord::Base

  belongs_to :user_sender, class_name: "User", foreign_key: "user_sender_id"
  belongs_to :user_target, class_name: "User", foreign_key: "user_target_id"

  validates_presence_of :user_sender, :user_target, :text, on: :create

  def sender
    @sender ||= if self.user_sender.present?
      user_sender
    else
      User.first
    end
  end

  def target
    # can be nil
    @target ||= user_target
  end
end
