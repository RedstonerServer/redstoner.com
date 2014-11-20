class Label < ActiveRecord::Base
  validates_presence_of :name
  belongs_to :role
  has_and_belongs_to_many :forums
  has_many :forumthreads

  def to_s
    name.upcase
  end

end