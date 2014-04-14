class Forumgroup < ActiveRecord::Base
  has_many :forums
  belongs_to :role_read, class_name: "Role", foreign_key: "role_read_id"
  belongs_to :role_write, class_name: "Role", foreign_key: "role_write_id"
  accepts_nested_attributes_for :forums



  validates_presence_of :name, :position
  validates_length_of :name, in: 2..20

  def to_s
    name
  end

  def can_read?(user)
    role_read.nil? || (!user.nil? && user.role >= role_read)
  end

  def can_write?(user)
    !user.nil? && can_read?(user) && user.confirmed? && (role_write.nil? || user.role >= role_write)
  end
end
