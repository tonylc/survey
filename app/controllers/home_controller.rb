# Main controller!
class HomeController < ApplicationController

  skip_before_filter :is_logged_in?, :only => :index

  def index
    if logged_in?
      if current_user.is_a?(Administrator)
        redirect_to :controller => :admin, :action => :index
      else
        redirect_to :controller => :survey, :action => :start_survey
      end
    end
  end
end
