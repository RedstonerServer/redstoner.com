module UsersHelper
require "open-uri"

  def mentions(content)
    users = []
    words = content.scan(/@[a-zA-Z0-9_]{1,16}/)
    words.each do |w|
      user = User.find_by_ign(w[1..-1])
      users << user if user && user.normal? && user.confirmed? && user.mail_mention?
    end
    users
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

  def fetch_name(uuid)
    uri  = URI.parse("https://api.mojang.com/user/profiles/#{CGI.escape(uuid)}/names")
    http = Net::HTTP.new(uri.host, uri.port)
    http.open_timeout = 3
    http.read_timeout = 3
    http.use_ssl = true

    begin
      response = http.get(uri)
      if response.code == "200"
        data = JSON.load(response.body)
        return data.last["name"]
      end
    rescue => e
      Rails.logger.error "----"
      Rails.logger.error "Failed to get mojang profile for #{uuid}"
      Rails.logger.error e.message
      Rails.logger.error "----"
      return nil
    end
  end

end