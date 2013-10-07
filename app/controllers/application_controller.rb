class ApplicationController < ActionController::Base
  protect_from_forgery

  # force_ssl

  helper :all
  include UsersHelper
  include ApplicationHelper

  helper_method :current_user
  helper_method :disabled?
  helper_method :banned?
  helper_method :confirmed?
  helper_method :unconfirmed?
  helper_method :default?
  helper_method :donor?
  helper_method :mod?
  helper_method :admin?
  helper_method :superadmin?

  private

  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end

  #roles
  def disabled?
    !!(current_user && current_user.disabled?)
  end

  def banned?
    !!(current_user && current_user.banned?)
  end

  def unconfirmed?
    !!(current_user && current_user.unconfirmed?)
  end

  #special one
  def confirmed?
    !!(current_user && current_user.confirmed?)
  end

  def default?
    !!(current_user && current_user.default?)
  end

  def donor?
    !!(current_user && current_user.donor?)
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

end