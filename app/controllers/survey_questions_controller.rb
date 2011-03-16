class SurveyQuestionsController < ApplicationController

  before_filter :is_logged_in?, :authenticate_admin

  def index
    @survey_questions = SurveyQuestion.find(:all, :order => "short_name ASC")
  end

  def edit
    @survey_question = SurveyQuestion.find(params[:id])
  end

  def update
    if request.post?
      logger.debug("******survey question to be saved is #{params.inspect}")
      survey_question = SurveyQuestion.find(params[:id])
      begin
        logger.debug("******before update #{survey_question.inspect}")
        survey_question.update_attributes!(params[:survey_question])
        logger.debug("******after update #{survey_question.inspect}")
        
        flash[:notice] = "Question updated!"
        redirect_to :action => :index
      rescue Exception => e
        flash[:error] = "There was an issue with updating the question. #{e.message}"
        redirect_to :back
      end
    else
      redirect_to :action => :index
    end
  end
end
