module Tools
  def Tools.avatar_url(user_id, size)
    u = User.find_by_id(user_id)
    u.nil? ? ign = :char : ign = u.ign
    return "https://minotar.net/avatar/#{ign}/#{size}"
  end

  def Tools.mc_running?
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

  def Tools.rank_to_int(rank)
    r = Tools.ranks[rank]
  end

  def Tools.int_to_rank(int)
    r = Tools.ranks.rassoc(int)
    r.nil? ? "unknown" : r[0].to_s
  end

  def Tools.ranks
    # Lower case !!!
    {:visitor => 10, :member => 20, "member+" => 25, :builder => 30, :donor => 40, "donor+" => 45, :mod => 100, :admin => 200, :superadmin => 500}
  end
end