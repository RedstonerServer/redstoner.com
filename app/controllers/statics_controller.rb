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
    @players = {}
    @count = 0
    begin
      json = JSON.parse(File.read("/etc/minecraft/redstoner/plugins/ModuleLoader/players.json"))
    rescue
      flash.now[:alert] = "The server is currently offline."
    else
      json["players"].each do |p|
        next if p["vanished"] == "true" && !mod?
        if User.find_by(uuid: p["UUID"].tr("-", ""))
          @players.push(User.find_by(uuid: p["UUID"].tr("-", "")))
        else
          @players.push(User.new(name: p["name"], ign: p["name"], uuid: p["UUID"].tr("-", ""), role: Role.get("normal"), badge: Badge.get("none"), confirmed: true))
        end
      end
    end
    @players.sort_by!(&:role).reverse!
    @count = @players.count
  end
end
