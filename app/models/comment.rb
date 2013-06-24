class Comment < ActiveRecord::Base
  attr_accessible :text, :user_id, :blogpost, :post
  validates_presence_of :text, :user_id, :blogpost_id
  belongs_to :blogpost
  belongs_to :user
end