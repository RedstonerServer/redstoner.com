class ApplicationController < ActionController::Base
  protect_from_forgery
  # force_ssl
  helper :all
  include UsersHelper
  helper_method :current_user
  helper_method :mod?
  helper_method :admin?
  helper_method :superadmin?

  private

  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end

  def mod?
    !!(current_user && current_user.rank >= rank_to_int("mod"))
  end

  def admin?
    !!(current_user && current_user.rank >= rank_to_int("admin"))
  end

  def superadmin?
    !!(current_user && current_user.rank >= rank_to_int("superadmin"))
  end

end