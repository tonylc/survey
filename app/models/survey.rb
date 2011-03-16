class Survey < ActiveRecord::Base
  belongs_to :user
  has_one :survey_answer, :dependent => :destroy

  def status
    if self.page_complete == 0
      return "Unopened"
    elsif self.all_pages_complete?
      return "Complete"
    else
      return "Incomplete"
    end
  end

  def all_pages_complete?
    return self.page_complete == APP_CONFIG["number_of_pages"]
  end

  def set_survey_answer_set(survey_answer_set)
    if !self.survey_answer
        self.survey_answer = SurveyAnswer.new(survey_answer_set)
      else
        self.survey_answer.update_attributes(survey_answer_set)
      end
  end
end
