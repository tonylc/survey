# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController

  skip_before_filter :is_logged_in?, :only => [:new, :create, :destroy]
  
  # render new.rhtml
  def new
    session[:user_id] = nil
  end

  def create
    self.current_user = User.authenticate(params[:login], params[:password])

    if logged_in?
      session[:user_id] = self.current_user.id
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      
      flash[:notice] = "Logged in successfully"

      if current_user.is_family_reporter?
        redirect_back_or_default(home_path)
      else
        redirect_back_or_default(home_path)
      end
    else
      flash[:error] = "Incorrect login"
      render :action => 'new'
    end
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    session.delete
    session[:user_id] = nil
    flash[:notice] = "You have been logged out."
    redirect_back_or_default(home_path)
  end
end
