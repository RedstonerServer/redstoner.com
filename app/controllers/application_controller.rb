class ApplicationController < ActionController::Base
  protect_from_forgery
  # force_ssl
  helper :all
  include UsersHelper
  helper_method :current_user

  private
  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end
end