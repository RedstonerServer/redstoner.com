module UsersHelper
require "open-uri"

  def mentions(content)
    words = content.scan(/@[a-zA-Z0-9_]{1,16}/)
    words.map! do |w|
      w[0] = ""
      w
    end
    User.where(ign: words).uniq!
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

end