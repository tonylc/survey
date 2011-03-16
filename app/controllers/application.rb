# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

  before_filter :is_logged_in?
  #helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery :secret => '939a9a59dcd018c5c10288a4f36f4ba3'
  
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  
  protected

  def is_logged_in?
    if !logged_in?
      redirect_to home_path
    end
  end

  def authenticate_admin
    if !current_user.is_admin?
      flash[:error] = "You do not have permission to access this page."
      redirect_to home_path
    end
  end

  def authenticate_not_admin
    if current_user.is_admin? && request.post?
      flash[:error] = "Admins cannot take the survey."
      redirect_to admin_path
    end
  end

  def authenticate_admin_or_family_reporter
    if !current_user.is_family_reporter? && !current_user.is_admin?
      flash[:error] = "You do not have permission to access this page."
      redirect_to home_path
    end
  end
end
