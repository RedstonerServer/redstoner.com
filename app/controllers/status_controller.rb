class StatusController < ApplicationController
  def show
    if params[:check]
      if params[:check].downcase == "minecraft"
        if port_open?("redstoner.com", 25565)
          send_file "app/assets/images/on.png", :type => "image/png", :disposition => "inline"
        else
          send_file "app/assets/images/off.png", :type => "image/png", :disposition => "inline"
        end
      elsif params[:check].downcase == "teamspeak"
        if port_open?("redstoner.com", 9987)
          send_file "app/assets/images/on.png", :type => "image/png", :disposition => "inline"
        else
          send_file "app/assets/images/off.png", :type => "image/png", :disposition => "inline"
        end
      else
        render :text => "invalid params"
      end
    end
  end
end