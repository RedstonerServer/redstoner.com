require "open-uri"
require "rexml/document"

module UsersHelper
  def mentions(content)
    users = []
    words = content.scan(/@[a-zA-Z0-9_]{1,16}/)
    words.each do |w|
      user = User.find_by_ign(w[1..-1])
      users << user if user && user.normal? && user.confirmed? && user.mail_mention?
    end
    users.uniq
  end

  def get_youtube(yt_channel)
    yt = {channel: yt_channel}
    if yt_channel.blank?
      yt[:channel] = nil
      yt[:channel_name] = nil
      yt[:is_correct?] = true
    else
      begin
        # TODO: This whole thing needs to be gone badly
        yt[:channel_name] = REXML::Document.new(open("https://www.youtube.com/feeds/videos.xml?channel_id=#{CGI.escape(yt_channel)}", :read_timeout => 1)).root.elements.find{ |n| n.name == "title" }.text
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