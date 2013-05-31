class ServercheckerController < ApplicationController
  def show
    require "Tools"
    if Tools.mc_running?
      send_file "app/assets/images/on.png", :type => "image/png", :disposition => "inline"
    else
      send_file "app/assets/images/off.png", :type => "image/png", :disposition => "inline"
    end
  end
end