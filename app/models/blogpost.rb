class Blogpost < ActiveRecord::Base
  attr_accessible :title, :text
  validates_presence_of :title, :text, :user
  belongs_to :user
  has_many :comments
end
