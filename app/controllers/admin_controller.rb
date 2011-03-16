class AdminController < ApplicationController

  before_filter :is_logged_in?, :authenticate_admin

  def index
    @admins = Administrator.find(:all)
  end

  def add_admin
    if request.post?
      @admin = Administrator.new(params[:administrator])
      if @admin.save
        @admin.send(:activate!)

        flash[:notice] = "Admin #{@admin.login} added!"
        redirect_to :action => :index
      end
    else
      @admin = Administrator.new
    end
  end

  def edit
    if request.post?
      logger.debug("******User to be updated is #{params.inspect}")
      @admin = Administrator.find(params[:id])

      begin
        logger.debug("******before update #{@admin.inspect}")
        @admin.update_attributes!(params[:administrator])
        logger.debug("******after update #{@admin.inspect}")

        flash[:notice] = "Info updated!"
        redirect_to :action => :index
      rescue
        flash[:error] = "There was an issue with updating your Info."
      end
    else
      @admin = Administrator.find(params[:id])
    end
  end

  def display_report
    @survey_answers = SurveyAnswer.find(:all, :conditions => ["family_id is not null"])
    set_user_statistics
  end

  def export_to_excel
    @download_to_excel = true
    @survey_answers = SurveyAnswer.find(:all, :conditions => ["family_id is not null"])
    set_user_statistics
    headers['Content-Type'] = "application/vnd.ms-excel"
    render :layout => false, :action => :display_report

#     e = Excel::Workbook
#     @survey_answers = SurveyAnswer.find(:all)
#     #@tasks = @project.tasks
#     e.addWorksheetFromActiveRecord "Project", "project", @project
#     #e.addWorksheetFromActiveRecord "Tasks", "task", @tasks
#     headers['Content-Type'] = "application/vnd.ms-excel"
#     render :text => e.build
   end

  private

  def set_user_statistics
    users = User.find(:all, :conditions => ["type is null OR type = 'FamilyReporter'"])
    @num_users = users.size
    @num_families = Family.count
    @num_unopened = 0
    @num_complete = 0
    @num_incomplete = 0

    users.each do |user|
      case user.survey_status
      when "Unopened"
        @num_unopened += 1
      when "Complete"
        @num_complete += 1
      when "Incomplete"
        @num_incomplete += 1
      end
    end
  end
end
