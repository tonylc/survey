class SurveyAnswerSortableByScore

  attr_reader :attribute, :score

  def initialize(attribute, score)
    @attribute = attribute
    @score = score
  end

  def self.sort_answer(survey_answer, limit, sort_by_future = nil)
    s_array = Array.new
    if sort_by_future.blank? || !sort_by_future
      score_type = "current"
    else
      score_type = "future"
    end

    SurveyAnswer::ATTRIBUTES.each do |attribute|

      method = "#{attribute}_#{score_type}_score_average"
      score = survey_answer.method(method).call

      s_array << SurveyAnswerSortableByScore.new(attribute, score)
    end

    sorted_array = s_array.sort { |a,b| a <=> b }
    # return in descending order
    sorted_array = sorted_array.reverse[0..(limit-1)].select {|sorted_survey_answer| sorted_survey_answer.score >= 3.0 }
    sorted_array
  end

  def self.sort_answer_by_current(survey_answer, limit=10)
    SurveyAnswerSortableByScore.sort_answer(survey_answer, limit, false)
  end

  def self.sort_answer_by_future(survey_answer, limit=10)
    SurveyAnswerSortableByScore.sort_answer(survey_answer, limit, true)
  end

  def <=> (other)
    self.score <=> other.score
  end
end