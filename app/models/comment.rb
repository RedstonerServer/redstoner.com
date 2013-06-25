class Comment < ActiveRecord::Base
  attr_accessible :text, :user, :blogpost, :post

  validates_presence_of :text, :user, :blogpost
  validates_length_of :text, :in => 4..1000


  belongs_to :blogpost
  belongs_to :user
end