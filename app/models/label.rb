class Label < ActiveRecord::Base
  validates_presence_of :name
  validate :color_valid
  has_and_belongs_to_many :forums
  has_many :forumthreads

  def to_s
    name.upcase
  end

  # calculate the foreground color
  # either black or white, based on the bg color
  def fcolor
    bg = color.dup
    # convert 3 char to 6 char hex
    bg.gsub!(/./, '\&\&') if bg.length == 3
    [0, 2, 4].each do |i|
      if bg[i..i+1] >= "7f"
        return "000"
      end
    end
    return "fff"
  end

  private

  def color_valid
    color.downcase!
    unless [3, 6].include? color.length
      errors.add(:color, "Must be 3 or 6 characters long")
    end
    valid_chars = ("0".."9").to_a + ("a".."f").to_a
    color.split("").each do |c|
      unless valid_chars.include? c
        errors.add(:color, "Must be a valid HEX code")
        return
      end
    end
  end
end