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
    @players = JSON.parse(File.read("/etc/minecraft/redstoner/plugins/JavaUtils/players.json"))["players"]
    @players.collect!{ |p| User.find_by(uuid: p["uuid"].tr("-", "")) or User.new(name: p["name"], ign: p["name"], uuid: p["uuid"].tr("-", ""), role: Role.get("normal"), confirmed: true) }.sort_by!(&:role).reverse!
  end
end
