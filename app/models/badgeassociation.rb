class Badgeassociation < ActiveRecord::Base

  belongs_to :badge
  belongs_to :forum
  belongs_to :forumgroup

end
