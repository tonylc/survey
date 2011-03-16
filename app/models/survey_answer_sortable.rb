class SurveyAnswerSortable

  @attributes = [:direction, :connection, :communication, :community,
      :achieve_purpose, :shared_agreements, :exit_options,
      :financial_accountability, :financial_management, :future_generations,
      :leadership_transition, :next_gen_leader, :financial_stewardship, :personal_fulfillment].freeze

  attr_reader :attribute, :score, :gap_score

  def initialize(attribute, score, gap_score)
    @attribute = attribute
    @score = score
    @gap_score = gap_score
  end

  def self.sort_answer(survey_answer, sort_by_future = nil)
    s_array = Array.new
    if sort_by_future.blank? || !sort_by_future
      score_type = "current"
    else
      score_type = "future"
    end

    @attributes.each do |attribute|

      method = "#{attribute}_#{score_type}_score"
      gap_method = "#{attribute}_gap_score"
      score = survey_answer.method(method).call
      gap_score = survey_answer.method(gap_method).call

      s_array << SurveyAnswerSortable.new(attribute, score, gap_score)
    end

    sorted_array = s_array.sort { |a,b| a <=> b }
    # return in descending order
    sorted_array.reverse.collect { |sas| sas.attribute }
  end

  def self.sort_answer_by_current(survey_answer)
    SurveyAnswerSortable.sort_answer(survey_answer, false)
  end

  def self.sort_answer_by_future(survey_answer)
    SurveyAnswerSortable.sort_answer(survey_answer, true)
  end

  def <=> (other)
    if self.score == other.score
      self.gap_score <=> other.gap_score
    else
      self.score <=> other.score
    end
  end
end