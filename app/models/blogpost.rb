class Blogpost < ActiveRecord::Base
  attr_accessible :title, :text
  validates_presence_of :title, :text, :user
  belongs_to :user
  has_many :comments
  accepts_nested_attributes_for :comments
end
