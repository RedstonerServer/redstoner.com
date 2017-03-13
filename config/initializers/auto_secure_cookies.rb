# rails only allows to globally flag session cookies as either secure or not
# this patch sets the secure flag for cookies based on the protocol (@secure)
# this is used to send cookies via http but flag them secure for https
# which allows use with HTTP over Tor for an onion domain
# this is acceptable because nginx redirects clearnet http to https

module ActionDispatch
  class Cookies
    class CookieJar
      private
      def write_cookie?(cookie)
        cookie[:secure] = @secure
        true
      end
    end
  end
end
