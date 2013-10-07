class User < ActiveRecord::Base
  include UsersHelper
  belongs_to :role
  attr_accessible :name, :password, :password_confirmation, :ign, :email, :confirm_code, :about, :last_ip, :skype, :skype_public, :youtube, :youtube_channelname, :twitter, :last_login, :role

  has_secure_password

  before_validation :strip_whitespaces

  validates_presence_of :password, :password_confirmation, :confirm_code, :on => :create
  validates_presence_of :name, :email, :ign

  validates_length_of :password, in: 8..256, :on => :create
  validates_length_of :name, in: 3..20
  validates_length_of :about, maximum: 5000
  validates_length_of :ign, minimum: 2

  validates :email, uniqueness: {case_sensitive: false}, format: {with: /^\S+@\S+\.[a-z]{2,}$/i, message: "That doesn't look like an email adress."}
  validates :name, uniqueness: {case_sensitive: false}, format: {with: /^[a-z\d\-_ ]+$/i, message: "Allowed characters: a-z0-9, dashes, underscores and spaces"}
  validates :ign, uniqueness: {case_sensitive: false}, format: {with: /^[a-z\d_]+$/i, message: "That is probably not your username."}

  validate :ign_is_not_skull, :ign_is_not_mojang, :ign_has_paid, :ign_has_correct_case

  has_many :blogposts
  has_many :comments

  def is? (user)
    self == user
  end

  #roles
  def disabled?
    !!(self.role == :disabled)
  end

  def banned?
    !!(self.role == :banned)
  end

  def unconfirmed?
    !!(self.role == :unconfirmed)
  end

  def confirmed?
    !!(self.role > :unconfirmed)
  end

  def default?
    !!(self.role >= :default)
  end

  def donor?
    !!(self.role >= :donor)
  end

  def mod?
    !!(self.role >= :mod)
  end

  def admin?
    !!(self.role >= :admin)
  end

  def superadmin?
    !!(self.role >= :superadmin)
  end

  private

  def ign_is_not_skull
    errors.add(:ign, "Good one...") if ["MHF_Blaze", "MHF_CaveSpider", "MHF_Chicken", "MHF_Cow", "MHF_Enderman", "MHF_Ghast", "MHF_Golem", "MHF_Herobrine", "MHF_LavaSlime", "MHF_MushroomCow", "MHF_Ocelot", "MHF_Pig", "MHF_PigZombie", "MHF_Sheep", "MHF_Slime", "MHF_Spider", "MHF_Squid", "MHF_Villager", "MHF_Cactus", "MHF_Cake", "MHF_Chest", "MHF_Melon", "MHF_OakLog", "MHF_Pumpkin", "MHF_TNT", "MHF_TNT2", "MHF_ArrowUp", "MHF_ArrowDown", "MHF_ArrowLeft", "MHF_ArrowRight", "MHF_Exclamation", "MHF_Question"].include?(self.ign)
  end

  def ign_is_not_mojang
    errors.add(:ign, "If that's really you, contact <a href='/users?role=staff'>us</a> in-game.") if ["mollstam", "carlmanneh", "MinecraftChick", "Notch", "jeb_", "xlson", "jonkagstrom", "KrisJelbring", "marc", "Marc_IRL", "MidnightEnforcer", "YoloSwag4Lyfe", "EvilSeph", "Grumm", "Dinnerbone", "geuder", "eldrone", "JahKob", "BomBoy", "MansOlson", "pgeuder", "91maan90", "vubui", "PoiPoiChen", "mamirm", "eldrone", "_tomcc"].include?(self.ign)
  end

  def ign_has_paid
    errors.add(:ign, "'#{self.ign}' is not a valid account!") unless haspaid?(self.ign)
  end

  def ign_has_correct_case
    errors.add(:ign, "The IGN is case-sensitive. Please correct '#{self.ign}'.") unless correct_case?(self.ign)
  end

  def strip_whitespaces
    self.name.strip! if self.name
    self.ign.strip! if self.ign
    self.email.strip! if self.email
    self.about.strip! if self.about
    self.skype.strip! if self.skype
    self.youtube.strip! if self.youtube
    self.twitter.strip! if self.twitter
  end
end