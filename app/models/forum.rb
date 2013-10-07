class Forum < ActiveRecord::Base
  belongs_to :forumgroup
  has_many :forumthreads

  def to_s
    name
  end

  def group
    forumgroup
  end
end
