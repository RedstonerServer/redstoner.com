class Info < ActiveRecord::Base
  self.table_name = "info"

  validates_presence_of :title, :content

  def to_s
    title
  end

  def to_param
    [id, to_s.parameterize].join("-")
  end

end