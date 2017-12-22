class Forum < ActiveRecord::Base
  belongs_to :forumgroup
  has_many :forumthreads

  has_many :badgeassociations
  has_many :badges, through: :badgeassociations

  belongs_to :role_read, class_name: "Role", foreign_key: "role_read_id"
  belongs_to :role_write, class_name: "Role", foreign_key: "role_write_id"
  has_and_belongs_to_many :labels
  validates_length_of :name, in: 4..30

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
    group && group.can_read?(user) && (role_read.nil? || (!user.nil? && user.role >= role_read) || Badgeassociation.find_by(badge: user.badge, forum: self, permission: 1))
  end

  def can_write?(user)
    group.can_write?(user) && (role_write.nil? || (!user.nil? && user.role >= role_write || Badgeassociation.find_by(badge: user.badge, forum: self, permission: 2)))
  end

  def can_view?(user)
    can_read?(user) || can_write?(user)
  end

  def to_param
    [id, to_s.parameterize].join("-")
  end
end
