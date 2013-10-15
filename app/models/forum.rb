class Forum < ActiveRecord::Base
  belongs_to :forumgroup
  has_many :forumthreads
  belongs_to :role_read, class_name: "Role", foreign_key: "role_read_id"
  belongs_to :role_write, class_name: "Role", foreign_key: "role_write_id"

  attr_accessible :name, :position, :role_read, :role_write, :role_read_id, :role_write_id, :forumgroup, :forumgroup_id

  def to_s
    name
  end

  def group
    forumgroup
  end
end
