class Comment < ActiveRecord::Base
  attr_accessible :text, :user, :blogpost, :post
  validates_presence_of :text, :user, :blogpost
  belongs_to :blogpost
  belongs_to :user
end