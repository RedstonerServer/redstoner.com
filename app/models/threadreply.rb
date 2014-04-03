class Threadreply < ActiveRecord::Base
  belongs_to :forumthread
  belongs_to :user_author, class_name: "User", foreign_key: "user_author_id"
  belongs_to :user_editor, class_name: "User", foreign_key: "user_editor_id"

  attr_accessible :title, :content, :sticky, :locked, :user_author, :user_editor, :forumthread

  validates_presence_of :content
  validates_length_of :content, in: 2..10000

  def author
    @author ||= if self.user_author.present?
      user_author
    else
      User.first
    end
  end

  def editor
    @editor ||= user_editor
  end
end