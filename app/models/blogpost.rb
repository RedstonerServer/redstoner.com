class Blogpost < ActiveRecord::Base

  validates_presence_of :title, :content, :author
  belongs_to :user_author, class_name: "User", foreign_key: "user_author_id"
  belongs_to :user_editor, class_name: "User", foreign_key: "user_editor_id"
  has_many :comments, :dependent => :destroy
  accepts_nested_attributes_for :comments

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
