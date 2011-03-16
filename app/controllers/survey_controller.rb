class SurveyController < ApplicationController

  before_filter :is_logged_in?
  before_filter :authenticate_not_admin
  before_filter :enforce_page_order, :only => :page
  
  def index
    redirect_to :action => :start_survey
  end

  def start_survey
    @user = current_user
    if @user && @user.survey.nil?
      @survey = Survey.new(:user_id => @user.id, :page_complete => 0)
      begin
        @survey.save! if current_user.only_if_not_admin
      rescue Exception => e
        logger.error("Exception occured in start_survey #{e.message}")
        flash[:error] = "An error occured, please try again!"
        redirect_to :controller => :home, :action => :index
      end
    else
      @survey = current_user.survey
    end
  end
  
  def results
    if current_user.is_admin?
      @family_answers = [SurveyAnswer.mock, SurveyAnswer.mock, SurveyAnswer.mock, SurveyAnswer.mock, SurveyAnswer.mock, SurveyAnswer.mock, SurveyAnswer.mock, SurveyAnswer.mock, SurveyAnswer.mock]
    else
      family_members = current_user.find_all_family_members
      family_members.delete(current_user)
      # ensures current user is at the front of the array
      family_members.unshift(current_user)
      @family_answers = family_members.collect {|member| member.survey.survey_answer }
    end
  end
  
  def strengths_and_improvement
    if current_user.is_admin?
      @family_survey = SurveyAnswer.mock(:answer_111_a => 1.0,
                                         :answer_111_b => 4.0,
                                         :answer_112_a => 1.0,
                                         :answer_112_b => 4.0,
                                         :answer_113_a => 1.0,
                                         :answer_113_b => 4.0,
                                         :answer_211_a => 4.0,
                                         :answer_211_b => 4.0,
                                         :answer_212_a => 4.0,
                                         :answer_212_b => 4.0,
                                         :answer_213_a => 4.0,
                                         :answer_213_b => 4.0)
    else
      @family_survey = SurveyAnswer.find(:first, :conditions => {:family_id => current_user.family_id})
    end
  end

  def page
    @page_num = params[:survey_page_num].to_i

    @survey_questions = SurveyQuestion.find(:all, :conditions => {:page_number => @page_num})
    if @survey_questions.size == 0
      flash[:error] = "You have requested an invalid page!"
      redirect_to :controller => :home, :action => :index
      return
    end

    current_survey = current_user.get_survey
    @survey_answer = current_survey.survey_answer.nil? ? SurveyAnswer.new : current_survey.survey_answer

    if request.post?

      # save whatever they got so far...
      if current_survey.survey_answer
        current_survey.survey_answer.update_attributes(params[:survey_answer])
      else
        @survey_answer = SurveyAnswer.new(params[:survey_answer])
      end

      @survey_questions.each do |survey_question|
        if params[:survey_answer].blank? || params[:survey_answer]["#{survey_question.short_name}_a".to_sym].blank? || params[:survey_answer]["#{survey_question.short_name}_b".to_sym].blank?
          # user didn't fill in everything
          respond_to do |format|
            logger.info("User #{current_user.id} did not make any selections, redirecting back to page #{@page_num}")
            flash[:error] = "Fill in all selections before continuing (*)"
            format.html do
              @empty = true
              render :action => :page, :survey_page_num => @page_num
            end
          end
          # important so it doesn't continue down the page....
          return
        end
      end

      current_survey.set_survey_answer_set(params[:survey_answer])

      respond_to do |format|
        current_survey.send("page_complete=".to_sym, @page_num)
        if current_survey.save
          format.html do
            if @page_num == APP_CONFIG["number_of_pages"]
              begin
                create_or_integrate_to_family_average(current_user)
                # we're done!
                redirect_to :action => :results
              rescue Exception => e
                logger.error("Exception occured while trying to save family survey: #{e.message}")
                flash[:error] = "Save didn't work, please try again!"
                redirect_to :action => :page, :survey_page_num => APP_CONFIG["number_of_pages"]
              end
            else
              redirect_to :action => :page, :survey_page_num => @page_num + 1
            end
          end
        else
          logger.info("Update didn't work because #{current_survey.survey_answer.errors.full_messages}")
          flash[:error] = 'Fill in required selection before continuing.'
          format.html { render :action => :page, :survey_page_num => @page_num }
        end
      end
    end
  end

  def strengths_and_areas_of_development
    current_survey = current_user.get_survey
    if incomplete_survey?(current_survey)
      flash[:error] = "* You did not finish filling out a survey, please fill out each question."
      redirect_to :action => :page, :survey_page_num => 1
      return
    end

    @survey_answer = current_user.get_survey_answer
    @family_answer = current_user.get_family_answer
    @should_show_family = current_user.has_family?
    @attributes = SurveyAnswerSortable.sort_answer_by_current(@survey_answer)
    @family_attributes = SurveyAnswerSortable.sort_answer_by_current(@family_answer)
  end
  
  def scoring_summary
    current_survey = current_user.get_survey
    if incomplete_survey?(current_survey)
      flash[:error] = "* You did not finish filling out a survey, please fill out each question."
      redirect_to :action => :page, :survey_page_num => 1
      return
    end
    @survey_answer = current_user.get_survey_answer
    @family_answer = current_user.get_family_answer
    @num_family_members = current_user.get_num_family_completed_surveys

    # UNCOMMENT LATER! session[:survey] = nil
    #session[:user_id] = nil
    
    #@graph = open_flash_chart_object(600,300, url_for(:controller => :survey, :action => :graph_result), true, '/assets/')
  end
  
  def graph_result
    current_survey = current_user.survey 
    survey_answer = current_survey.survey_answer

    user_current = LineHollow.new(2,5,'#FF0000')
    user_current.key("Current",10)
    
    user_current.add_data_tip(@template.results_part_2_view(survey_answer.direction_current_score / 3), '')
    user_current.add_data_tip(@template.results_part_2_view(survey_answer.connection_current_score / 3), '')
    user_current.add_data_tip(@template.results_part_2_view(survey_answer.communication_current_score / 3), '')
    user_current.add_data_tip(@template.results_part_2_view(survey_answer.community_current_score / 3), '')
    
    user_current.add_data_tip(@template.results_part_2_view(survey_answer.achieve_purpose_current_score / 3), '')
    user_current.add_data_tip(@template.results_part_2_view(survey_answer.shared_agreements_current_score / 4), '')
    user_current.add_data_tip(@template.results_part_2_view(survey_answer.exit_options_current_score / 3), '')
    
    user_current.add_data_tip(@template.results_part_2_view(survey_answer.financial_accountability_current_score / 3), '')
    user_current.add_data_tip(@template.results_part_2_view(survey_answer.financial_management_current_score / 3), '')
    user_current.add_data_tip(@template.results_part_2_view(survey_answer.future_generations_current_score / 3), '')
    
    user_current.add_data_tip(@template.results_part_2_view(survey_answer.leadership_transition_current_score / 3), '')
    user_current.add_data_tip(@template.results_part_2_view(survey_answer.next_gen_leader_current_score / 3), '')
    user_current.add_data_tip(@template.results_part_2_view(survey_answer.financial_stewardship_current_score / 3), '')
    user_current.add_data_tip(@template.results_part_2_view(survey_answer.personal_fulfillment_current_score / 3), '')

    user_future = LineHollow.new(2,5,'#0000FF')
    user_future.key("Future", 10)
    
    user_future.add_data_tip(@template.results_part_2_view(survey_answer.direction_future_score / 3), '')
    user_future.add_data_tip(@template.results_part_2_view(survey_answer.connection_future_score / 3), '')
    user_future.add_data_tip(@template.results_part_2_view(survey_answer.communication_future_score / 3), '')
    user_future.add_data_tip(@template.results_part_2_view(survey_answer.community_future_score / 3), '')
    
    user_future.add_data_tip(@template.results_part_2_view(survey_answer.achieve_purpose_future_score / 3), '')
    user_future.add_data_tip(@template.results_part_2_view(survey_answer.shared_agreements_future_score / 4), '')
    user_future.add_data_tip(@template.results_part_2_view(survey_answer.exit_options_future_score / 3), '')
    
    user_future.add_data_tip(@template.results_part_2_view(survey_answer.financial_accountability_future_score / 3), '')
    user_future.add_data_tip(@template.results_part_2_view(survey_answer.financial_management_future_score / 3), '')
    user_future.add_data_tip(@template.results_part_2_view(survey_answer.future_generations_future_score / 3), '')
    
    user_future.add_data_tip(@template.results_part_2_view(survey_answer.leadership_transition_future_score / 3), '')
    user_future.add_data_tip(@template.results_part_2_view(survey_answer.next_gen_leader_future_score / 3), '')
    user_future.add_data_tip(@template.results_part_2_view(survey_answer.financial_stewardship_future_score / 3), '')
    user_future.add_data_tip(@template.results_part_2_view(survey_answer.personal_fulfillment_future_score / 3), '')

    g = Graph.new
    g.title("Dimensions", "{font-size: 20px; color: #736AFF}")
    g.data_sets << user_current
    g.data_sets << user_future

    g.set_tool_tip('#x_label# [#val#]<br>#tip#')
    g.set_x_labels(%w(1 2 3 4 5 6 7 8 9 10 11 12 13 14))
    g.set_x_label_style(10, '#000000', 0, 2)

    g.set_y_max(5)
    g.set_y_label_steps(5)
    g.set_y_legend("Score", 12, "#736AFF")

    render :text => g.render
  end

  def further_development
    current_survey = current_user.get_survey
    if incomplete_survey?(current_survey)
      flash[:error] = "* You did not finish filling out a survey, please fill out each question."
      redirect_to :action => :page, :survey_page_num => 1
      return
    end

    @survey_answer = current_user.get_survey_answer
    @family_answer = current_user.get_family_answer
    @should_show_family = current_user.has_family?
    @attributes = SurveyAnswerSortable.sort_answer_by_future(@survey_answer)
    @family_attributes = SurveyAnswerSortable.sort_answer_by_future(@family_answer)
  end

  private
  
  def incomplete_survey?(survey)
    return survey.page_complete != APP_CONFIG["number_of_pages"] && !current_user.is_admin?
  end

  def enforce_page_order

    if !APP_CONFIG["enforce_page_order"] || current_user.is_admin?
      return
    end
    
    current_survey = current_user.survey

    if current_survey.page_complete == APP_CONFIG["number_of_pages"]
      redirect_to :action => :results
    else
      next_survey_page = current_survey.page_complete + 1
      redirect_to :action => :page, :survey_page_num => next_survey_page unless request.parameters[:survey_page_num].to_i == next_survey_page
    end
  end

  def create_or_integrate_to_family_average(user)
    logger.debug("*******in create_or_integrate_to_family_average")
    family_survey = SurveyAnswer.find(:first, :conditions => {:family_id => user.family_id})

    if family_survey.nil?
      logger.debug("*******creating a survey answer")
      # creating a survey_answer if it didn't already exist
      family_survey = SurveyAnswer.new(:family_id => user.family_id)
      family_survey.attributes.each_key do |attribute_name|
        if attribute_name.include?("answer")
          family_survey.send("#{attribute_name}=".to_sym, user.survey.survey_answer[attribute_name])
        end
      end
    else
      logger.debug("*******integrating a survey answer")
      family_members = user.find_all_family_members
      logger.debug("family members is #{family_members.size}")
      # family survey just keeps aggregate result
      # this meanas users cannot re-edit their answers...
      # if they can, will need to re-calculate
      family_survey.attributes.each_key do |attribute_name|
        if attribute_name.include?("answer")
          
          sum = 0

          family_members.each do |family_member|
            logger.debug("********* survey is #{family_member.survey.id}")
            family_response = family_member.survey.survey_answer[attribute_name]
            sum += family_response unless family_response.blank?
          end

          avg = (sum.to_f / family_members.size.to_f)

          family_survey.send("#{attribute_name}=".to_sym, avg)
        end
      end
    end

    # need to save the survey
    family_survey.save! if !current_user.is_admin?
  end
  
end
