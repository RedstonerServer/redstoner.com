class StaticsController < ApplicationController

  caches_action :online, expires_in: 10.seconds, layout: false

  def index
    if current_user
      redirect_to blogposts_path
    else
      redirect_to home_statics_path
    end
  end

  def home
  end

  def donate
  end

  def online
    @players = []
    @count = 0
    begin
      json = JSON.parse(File.read("/etc/minecraft/redstoner/plugins/ModuleLoader/players.json"))
    rescue
      flash.now[:alert] = "The server is currently offline."
    else
      case json["dataFormat"]
      when "v1"
        @players = json["players"].collect!{ |p| User.find_by(uuid: p["UUID"].tr("-", "")) or User.new(name: p["name"], ign: p["name"], uuid: p["UUID"].tr("-", ""), role: Role.get("normal"), badge: Badge.get("none"), confirmed: true) }
        @count = json["amount"]
      when "v2"
        json["players"].reject{|p| !mod? && p["vanished"] == "true"}.each do |p|
          @players.push(User.find_by(uuid: p["UUID"].tr("-", "")) || User.new(name: p["name"], ign: p["name"], uuid: p["UUID"].tr("-", ""), role: Role.get("normal"), badge: Badge.get("none"), confirmed: true))
        end
        @count = @players.count
      else
        flash.now[:alert] = "The server is using an incompatible data format. We are aware of this issue and are most likely already working on it."
      end
      @players.sort_by!(&:role).reverse!
    end
  end
end
