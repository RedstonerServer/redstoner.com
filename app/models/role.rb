class Role < ActiveRecord::Base
  include Comparable
  has_many :users

  validates :color, format: {with: /#[0-9a-f]{3,6}/i}


  def to_s
    self.name
  end

  def to_i
    self.value
  end

  def is? (name)
    !!(Role.find_by_name(name) == self)
  end

  def self.get (input)
    if input.is_a?(String) || input.is_a?(Symbol)
      Role.find_by_name(input)
    elsif input.is_a?(Fixnum)
      Role.find_by_id(input)
    elsif input.is_a?(Role)
      return input
    end
  end

  def <=> (role)
    if role.is_a?(Role)
      self.value - role.value
    elsif role.is_a?(Symbol)
      self <=> Role.find_by_name(role)
    else
      self.to_i <=> role
    end
  end

  def self.all_to (role)
    Role.order(:value).select do |r|
      r <= role
    end
  end

  def self.all_from(role)
    Role.order(:value).select do |r|
      r >= role
    end
  end

  def self.all_from_to(from, to)
    Role.order(:value).select {|r| r >= from}.select {|r| r <= to}
  end

end