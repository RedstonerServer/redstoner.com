class User < ActiveRecord::Base
  attr_accessible :name, :ign, :email, :about, :password, :password_confirmation
  has_secure_password
  validates_presence_of :password, :on => :create

  has_many :blogposts
  has_many :comments
end