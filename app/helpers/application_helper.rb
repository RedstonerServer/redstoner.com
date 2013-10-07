module ApplicationHelper
  def port_open?(host, port)
    wait = 300/1000.0 #milliseconds, the .0 is required!!
    require 'timeout'
    require 'socket'
    isopen = false
    begin
      Timeout::timeout(wait) {
        TCPSocket.new host, port
        isopen = true
      }
    rescue Exception
      # could not connect to the server
    end
    return isopen
  end
end