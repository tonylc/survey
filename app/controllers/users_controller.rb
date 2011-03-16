class UsersController < ApplicationController
  # Protect these actions behind an admin login
  # before_filter :admin_required, :only => [:suspend, :unsuspend, :destroy, :purge]
  skip_before_filter :is_logged_in?, :only => [:activate, :change_password, :forgot_password, :reset_password]
  before_filter :find_user, :only => [:suspend, :unsuspend, :destroy, :purge]
  before_filter :authenticate_admin_or_family_reporter, :only => [:email_registration]
  before_filter :authenticate_user_info, :only => [:edit, :view]

  # render new.rhtml
  def new
  end

  def edit
    if request.post?
      logger.debug("******User to be updated is #{params.inspect}")

      begin
        logger.debug("******before update #{@user.inspect}")
        @user.update_attributes!(params[:user])
        logger.debug("******after update #{@user.inspect}")

        flash[:notice] = "Info updated!"
        redirect_to :action => :view, :id => @user.id
      rescue
        flash[:error] = "There was an issue with updating your Info."
      end
    end
  end

  def view
  end

  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new(params[:user])
    @user.family_id = current_user.family_id
    current_family = Family.find_by_id(current_user.family_id)
    current_family.validates_ability_to_add_new_members
    raise ActiveRecord::RecordInvalid.new(@user) unless @user.valid?
    @user.register!
    
    flash[:notice] = "You just signed up #{@user.first_name}."
  rescue ActiveRecord::RecordInvalid
    render :action => 'new'
  rescue ActiveRecord::RecordNotSaved => e
    flash[:error] = e.message
    render :action => 'new'
  end

  def activate
    new_user = User.find_by_activation_code(params[:activation_code])
    if new_user.nil?
      flash[:error] = "You have an invalid activation code!"
      redirect_to home_path
    end

    #self.current_user = params[:activation_code].blank? ? :false : User.find_by_activation_code(params[:activation_code])
    @user = new_user
    @activation_code = params[:activation_code]
    
    if request.post?
      begin
        self.current_user = new_user
        if logged_in? && !current_user.active?
          @user.update_attributes!(params[:user])
          @user.activate!
          flash[:notice] = "Signup complete!"
          self.current_user = @user
        end
        redirect_to home_path
      rescue Exception => e
        logger.warn("***********Exception in users/activate is #{e.message}")
        flash[:error] = "An error occurred, please try again!"
        self.current_user = nil
      end
    end    
  end

  def suspend
    @user.suspend! 
    redirect_to users_path
  end

  def unsuspend
    @user.unsuspend! 
    redirect_to users_path
  end

  def destroy
    @user.delete!
    redirect_to users_path
  end

  def purge
    @user.destroy
    redirect_to users_path
  end

  def change_password
    return unless request.post?
    if User.authenticate(current_user.login, params[:old_password])
      if ((params[:password] == params[:password_confirmation]) && !params[:password_confirmation].blank?)
        current_user.password_confirmation = params[:password_confirmation]
        current_user.password = params[:password]

        if current_user.save
          flash[:notice] = "Password successfully updated" 
          redirect_to profile_url(current_user.login)
        else
          flash[:error] = "Password not changed"
        end

      else
        flash[:error] = "New Password mismatch"
        @old_password = params[:old_password]
      end
    else
      flash[:error] = "Old password incorrect"
    end
  end

  #gain email address
  def forgot_password
    return unless request.post?
    if @user = User.find_by_email(params[:user][:email])
      @user.forgot_password
      if @user.save
        UserMailer.deliver_forgot_password(@user)
        redirect_back_or_default('/')
        flash[:notice] = "A password reset link has been sent to your email address"
      else
        flash[:error] = "There was an error processing that request.  Please contact Relative-Solutions at info@relative-solutions.com"
      end
    else
      flash[:error] = "Could not find a user with that email address"
    end
  end

  #reset password
  def reset_password
    @user = User.find_by_password_reset_code(params[:id])
    if !@user
      flash[:error] = "Your password reset code is invalid!"
      redirect_to home_path
    end
    #unless params[:user]
    if request.post?
    if ((params[:user][:password] && params[:user][:password_confirmation]) && !params[:user][:password_confirmation].blank?)
      if params[:user][:password_confirmation] == params[:user][:password]
        self.current_user = @user #for the next two lines to work

        current_user.password_confirmation = params[:user][:password_confirmation]
        current_user.password = params[:user][:password]
        @user.reset_password

        flash[:notice] = current_user.save ? "Password reset success." : "Password reset failed."
        redirect_back_or_default('/')
      else
        flash[:error] = "Password mismatch"
      end      
    else
      flash[:error] = "Password mismatch"
    end
    end
  end

  def email_registration
    user = User.find_by_id(params[:user_id])
    if user
      UserMailer.deliver_signup_notification(user)
      flash[:notice] = "Email sent to #{user.full_name}"
    else
      flash[:error] = "User with ID: #{params[:user_id]} not found!"
    end

    redirect_back_or_default home_path
  end

protected
  def find_user
    @user = User.find(params[:id])
  end

  private

  def authenticate_user_info
    if current_user.is_a?(Administrator)
      # admin can view/update info on anyone
      @user = User.find_by_id(params[:id])
    elsif current_user.is_a?(FamilyReporter)
      # family reporters can view/update anyone within the family
      @user = User.find_by_id(params[:id], :conditions => ["family_id = ?", current_user.family_id])
    else
      # users can only view/update themselves
      @user = User.find_by_id(params[:id], :conditions => ["id = ?", current_user.id])
    end

    if @user.nil?
      flash[:error] = "You don't have permission to do that!"
      redirect_to :action => :view, :id => current_user.id
    end
  end

end