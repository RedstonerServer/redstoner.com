class Forumgroup < ActiveRecord::Base
  has_many :forums
  belongs_to :role_read, class_name: "Role", foreign_key: "role_read_id"
  belongs_to :role_write, class_name: "Role", foreign_key: "role_write_id"
  accepts_nested_attributes_for :forums

  has_many :badgeassociations
  has_many :badges, through: :badgeassociations

  validates_presence_of :name, :position
  validates_length_of :name, in: 4..20

  def to_s
    name
  end

  def can_read?(user)
    role_read.nil? || (!user.nil? && user.role >= role_read) || Badgeassociation.find_by(badge: user.badge, forumgroup: self, permission: 1)
  end

  def can_write?(user)
    !user.nil? && user.confirmed? && (role_write.nil? || user.role >= role_write) || Badgeassociation.find_by(badge: user.badge, forumgroup: self, permission: 2)
  end

  def can_view?(user)
    can_read?(user) || can_write?(user)
  end

  def to_param
    [id, to_s.parameterize].join("-")
  end
end
