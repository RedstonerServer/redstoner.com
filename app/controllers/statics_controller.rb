class StaticsController < ApplicationController

  def index
    if current_user
      redirect_to blogposts_path
    else
      redirect_to home_statics_path
    end
  end

  def home
  end

  def donate
  end

  def raise_500
    raise "Someone called /raise_500! OMG!"
  end

end
