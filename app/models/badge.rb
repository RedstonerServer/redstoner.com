class Badge < ActiveRecord::Base
  include Comparable
  has_many :users

  def self.get (input)
    if input.is_a?(String) || input.is_a?(Symbol)
      Badge.find_by(name: input)
    elsif input.is_a?(Fixnum)
      Badge.find_by(id: input)
    elsif input.is_a?(Badge)
      return input
    end
  end

  def to_s
    self.name
  end
end
