class Forumgroup < ActiveRecord::Base
  has_many :forums
  belongs_to :role_read, class_name: "Role", foreign_key: "role_read_id"
  belongs_to :role_write, class_name: "Role", foreign_key: "role_write_id"
  accepts_nested_attributes_for :forums

  attr_accessible :name, :position, :role_read, :role_write, :role_read_id, :role_write_id

  validates_presence_of :name, :position
  validates_length_of :name, in: 2..20

  def to_s
    name
  end
end
