class Role < ActiveRecord::Base
  include Comparable
  has_many :users
  attr_accessible :name, :value

  def to_s
    self.name
  end

  def to_i
    self.value
  end

  def is? (name)
    !!(Role.find_by_name(name) == self)
  end

  def self.get (name)
    Role.find_by_name(name)
  end

  def <=> (role)
    if role.is_a?(Role)
      self.value - role.value
    elsif role.is_a?(Symbol)
      self <=> Role.find_by_name(role)
    else
      raise "Cannot compare Role with #{role.class}"
    end
  end

  def self.all_until (role)
    Role.all.select do |r|
      r <= role
    end
  end

end