module UsersHelper
  def avatar_url(user_id, size)
    u = User.find_by_id(user_id)
    u.nil? ? ign = :char : ign = u.ign
    return "https://minotar.net/helm/#{ign}/#{size}"
  end

  def mc_running?
    host = "play.redstoner.com"
    port = 25565
    wait = 300/1000.0 #milliseconds, the .0 is required!!
    require 'timeout'
    require 'socket'
    r = false
    begin
      Timeout::timeout(wait) {
        TCPSocket.new host, port
        r = true
      }
    rescue Exception
      # could not connect to the server
    end
    return r
  end

  def rank_to_int(rank)
    r = ranks[rank]
  end

  def int_to_rank(int)
    r = ranks.rassoc(int)
    r.nil? ? "unknown" : r[0].to_s
  end

  def ranks
    # Lower case !!!
    {"banned" => 1, "unconfirmed" => 5, "default" => 10, "donor" => 40, "mod" => 100, "admin" => 200, "superadmin" => 500}
  end
end