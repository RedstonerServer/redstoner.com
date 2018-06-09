class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :update_ip, :update_seen, :check_banned, :check_2fa
  # TODO: use SSL


  helper :all
  include UsersHelper
  include ApplicationHelper

  helper_method :current_user
  helper_method :disabled?
  helper_method :banned?
  helper_method :normal?
  helper_method :mod?
  helper_method :admin?
  helper_method :superadmin?
  helper_method :donor?
  helper_method :confirmed?


  private

  def update_ip
    current_user && current_user.update_attribute(:last_ip, request.remote_ip)
  end

  def update_seen
    current_user && current_user.update_attribute(:last_seen, Time.now)
  end

  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end

  def check_banned
    if current_user && current_user.banned?
      session.delete(:user_id)
      flash[:alert] = "You are banned!"
      redirect_to login_path
    end
  end

  def check_2fa
    # Over complicated way of asking if the user is logged in as a mod without TOTP enabled while they are not on their login settings screen, logging out, or updating their login settings.
    if current_user && current_user.mod? && !current_user.totp_enabled? && !(controller_name == "users" && action_name == "edit_login") && !(controller_name == "sessions" && action_name == "destroy") && !(controller_name == "users" && action_name == "update_login")
      flash[:alert] = "Due to your staff rank, you are required to enable 2FA."
      redirect_to :controller => "users", :action => "edit_login", :id => current_user.id
    end
  end


  #roles
  def disabled?
    !!(current_user && current_user.disabled?)
  end

  def banned?
    !!(current_user && current_user.banned?)
  end

  def normal?
    !!(current_user && current_user.normal?)
  end

  def mod?
    !!(current_user && current_user.mod?)
  end

  def admin?
    !!(current_user && current_user.admin?)
  end

  def superadmin?
    !!(current_user && current_user.superadmin?)
  end

  def donor?
    !!(current_user && current_user.donor?)
  end

  def confirmed?
    !!(current_user && current_user.confirmed?)
  end

end
