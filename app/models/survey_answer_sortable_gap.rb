class SurveyAnswerSortableGap
  attr_reader :attribute, :current_score, :future_score

  def initialize(attribute, current_score, future_score)
    @attribute = attribute
    @current_score = current_score
    @future_score = future_score
  end
  
  def gap_score
    @future_score - @current_score
  end
  
  def self.sort_answer_by_gap(survey_answer)
    s_array = Array.new
    
    SurveyAnswer::ATTRIBUTES.each do |attribute|

      current_method = "#{attribute}_current_score_average"
      future_method = "#{attribute}_future_score_average"
      current_score = survey_answer.method(current_method).call
      future_score = survey_answer.method(future_method).call

      s_array << SurveyAnswerSortableGap.new(attribute, current_score, future_score) if current_score < 3.0 && future_score >= 3.0
    end
    
    sorted_array = s_array.sort { |a,b| a <=> b }.reverse
  end

  def <=> (other)
    self.gap_score <=> other.gap_score
  end
end