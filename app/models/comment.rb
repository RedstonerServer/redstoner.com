class Comment < ActiveRecord::Base

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
end