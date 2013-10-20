module UsersHelper
require "open-uri"

  def avatar_url(user_id, size)
    u = User.find_by_id(user_id)
    u.nil? ? ign = :char : ign = u.ign
    return "https://minotar.net/helm/#{CGI.escape(ign)}/#{CGI.escape(size.to_s)}"
  end

  def uses_mc_password?(ign, password)
    query = {
      user: ign,
      password: password,
      version: 9999 #just something high so it won't fail with "Old version"
    }.to_query
    begin
      #check if this user is an idiot and uses their mc password.
      mclogin = open("https://login.minecraft.net/?#{query}", :read_timeout => 1).read
    rescue
      puts "---"
      puts "ERROR: failed to check mc password for '#{ign}'. Login servers down?"
      puts "---"
    end
    !!mclogin.downcase.include?(ign.downcase)
  end

  def haspaid?(ign)
    query = {user: ign}.to_query
    begin
      response = open("https://minecraft.net/haspaid.jsp?#{query}", :read_timeout => 1).read
    rescue
      puts "---"
      puts "ERROR: failed to check for premium account for '#{ign}'. Minecraft servers down?"
      puts "---"
      response = "true"
    end
    !(response.casecmp("false") == 0)
  end

  def correct_case?(ign)
    begin
      http = Net::HTTP.start("skins.minecraft.net")
      skin = http.get("/MinecraftSkins/#{CGI.escape(ign)}.png")
      http.finish
    rescue
      puts "---"
      puts "ERROR: failed to get skin status code for '#{ign}'. Skin servers down?"
      puts "---"
    end
    skin.code != "404"
  end

  def get_youtube(yt_name)
    yt = {channel: yt_name}
    if yt_name.blank?
      yt[:channel] = nil
      yt[:channel_name] = nil
      yt[:is_correct?] = true
    else
      begin
        yt[:channel_name] = JSON.parse(open("https://gdata.youtube.com/feeds/api/users/#{CGI.escape(yt_name)}?alt=json", :read_timeout => 1).read)["entry"]["title"]["$t"]
        yt[:is_correct?] = true
      rescue
        yt[:is_correct?] = false
      end
    end
    yt
  end

  def link_user(user)
    link_to user.name, user, class: "role #{user.role.name}"
  end


end