class Forum < ActiveRecord::Base
  belongs_to :forumgroup
  has_many :forumthreads
  belongs_to :role_read, class_name: "Role", foreign_key: "role_read_id"
  belongs_to :role_write, class_name: "Role", foreign_key: "role_write_id"

  def to_s
    name
  end

  def group
    forumgroup
  end

  def threads
    forumthreads
  end

  def can_read?(user)
    group && group.can_read?(user) && (role_read.nil? || (!user.nil? && user.role >= role_read))
  end

  def can_write?(user)
    group.can_write?(user) && can_read?(user) && (role_write.nil? || (!user.nil? && user.role >= role_write))
  end

  def to_param
    [id, to_s.parameterize].join("-")
  end
end