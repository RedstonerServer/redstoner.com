class Forumgroup < ActiveRecord::Base
  has_many :forums

  def to_s
    name
  end
end
