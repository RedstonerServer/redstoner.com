class Badge < ActiveRecord::Base
  include Comparable
  has_many :users

  def self.get (input)
    if input.is_a?(String) || input.is_a?(Symbol)
      Badge.find_by_name(input)
    elsif input.is_a?(Fixnum)
      Badge.find_by_id(input)
    elsif input.is_a?(Badge)
      return input
    end
  end

  def <=> (badge)
    if badge.is_a?(Badge)
      self.value - badge.value
    elsif badge.is_a?(Symbol)
      self <=> Badge.find_by_name(badge)
    else
      self.to_i <=> badge
    end
  end

  def to_i
    self.value
  end

  def to_s
    self.name
  end

  def self.all_to (badge)
    Badge.order(:value).select do |b|
      b <= badge
    end
  end

  def self.all_from(badge)
    Badge.order(:value).select do |b|
      b >= badge
    end
  end
end
