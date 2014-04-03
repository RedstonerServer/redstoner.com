module UsersHelper
require "open-uri"


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