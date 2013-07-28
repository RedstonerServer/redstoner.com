class User < ActiveRecord::Base
  attr_accessible :name, :ign, :email, :about, :password, :password_confirmation, :rank, :skype, :skype_public, :youtube, :youtube_channelname, :twitter
  has_secure_password
  validates_presence_of :password, :name, :email, :ign, :password_confirmation, :on => :create
  validates :email, :uniqueness => true
  validates :name, :uniqueness => true
  validates :ign, :uniqueness => true

  has_many :blogposts
  has_many :comments

end