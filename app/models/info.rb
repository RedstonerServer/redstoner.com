class Info < ActiveRecord::Base
  self.table_name = "info"

  validates_presence_of :title, :content

end