class SurveyAnswer < ActiveRecord::Base
  belongs_to :survey
  validates_presence_of :survey_id, :unless => Proc.new { |survey_answer| !survey_answer.family_id.nil? }

#  def method_missing(method_id)
#    # matches for the method "attribute"_score_gap, which in turns calls
#    # future_"attribute"_score - current_"attribute"_score
#    regexp_gaps = Regexp.new("([a-z]+)(_score_gap)")
#    match_data = regexp_gaps.match(method_id.to_s)
#    if match_data
#      attribute_name = match_data.captures.first
#      current_method = "current_#{attribute_name}_score"
#      future_method = "future_#{attribute_name}_score"
#      return self.method(future_method).call - self.method(current_method).call
#    end
#
#    # matches for the method "attribute"_"attribute"_"attribute"_"attribute"_(current|future)_sum,
#    # which in turns sums the (current|future)_"attribute"_score's
#    regexp_sum = Regexp.new("sum_(current|future)_([a-z]+)_([a-z]+)_([a-z]+)_([a-z]+)")
#    match_data = regexp_sum.match(method_id.to_s)
#    if match_data
#      attributes_array = match_data.captures
#      current_or_future = extract_current_or_future_option!(attributes_array)
#      score = 0
#      attributes_array.each do |attribute|
#        score_method = "#{current_or_future}_#{attribute}_score"
#        score += self.method(score_method).call
#      end
#
#      return score
#    end
#
#    super
#  end

  ATTRIBUTES = [:direction, :connection, :communication, :community,
      :achieve_purpose, :shared_agreements, :exit_options,
      :financial_accountability, :financial_management, :future_generations,
      :leadership_transition, :next_gen_leader, :financial_stewardship, :personal_fulfillment].freeze
      
  def self.attribute_dimension(attribute)
    case attribute
    when :direction, :connection, :communication, :community
      "I"
    when :achieve_purpose, :shared_agreements, :exit_options
      "II"
    when :financial_accountability, :financial_management, :future_generations
      "III"
    when :leadership_transition, :next_gen_leader, :financial_stewardship, :personal_fulfillment
      "IV"
    end
  end

  def self.mock(attribute_hash = {})
    sa = SurveyAnswer.new
    SurveyAnswer.column_names.each do |column|
      if column.include?("answer")
        if attribute_hash[column.to_sym]
          sa.attributes = {column.to_sym => attribute_hash[column.to_sym]}
        elsif !attribute_hash.empty?
          # stub 0's here if attribute_hash has some vaues
          sa.attributes = {column.to_sym => 0.0}
        else
          sa.attributes = {column.to_sym => rand(4)}
        end
      end
    end
    sa
  end
  
  def self.mock_score
    rand(400) / 100.0
  end

  ###### page 1 #####
  def direction_current_score
    self.answer_111_a + self.answer_112_a + self.answer_113_a
  end
  
  def direction_current_score_average
    direction_current_score / 3
  end

  def direction_future_score
    self.answer_111_b + self.answer_112_b + self.answer_113_b
  end
  
  def direction_future_score_average
    direction_future_score / 3
  end

  def direction_gap_score
    direction_future_score - direction_current_score
  end

  def connection_current_score
    self.answer_121_a + self.answer_122_a + self.answer_123_a
  end
  
  def connection_current_score_average
    connection_current_score / 3
  end

  def connection_future_score
    self.answer_121_b + self.answer_122_b + self.answer_123_b
  end
  
  def connection_future_score_average
    connection_future_score / 3
  end

  def connection_gap_score
    connection_future_score - connection_current_score
  end

  def communication_current_score
    self.answer_131_a + self.answer_132_a + self.answer_133_a
  end
  
  def communication_current_score_average
    communication_current_score / 3
  end

  def communication_future_score
    self.answer_131_b + self.answer_132_b + self.answer_133_b
  end
  
  def communication_future_score_average
    communication_future_score / 3
  end

  def communication_gap_score
    communication_future_score - communication_current_score
  end

  def community_current_score
    self.answer_141_a + self.answer_142_a + self.answer_143_a
  end
  
  def community_current_score_average
    community_current_score / 3
  end

  def community_future_score
    self.answer_141_b + self.answer_142_b + self.answer_143_b
  end
  
  def community_future_score_average
    community_future_score / 3
  end

  def community_gap_score
    community_future_score - community_current_score
  end

  def sum_current_direction_connection_communication_community
    direction_current_score + connection_current_score + communication_current_score + community_current_score
  end

  def sum_future_direction_connection_communication_community
    direction_future_score + connection_future_score + communication_future_score + community_future_score
  end

  def sum_gap_direction_connection_communication_community
    sum_future_direction_connection_communication_community - sum_current_direction_connection_communication_community
  end
  
  def current_dimension_1_average
    self.sum_current_direction_connection_communication_community / 12
  end
  
  def future_dimension_1_average
    self.sum_future_direction_connection_communication_community / 12
  end
  
  ###### page 2 #####

  def achieve_purpose_current_score
    self.answer_211_a + self.answer_212_a + self.answer_213_a
  end
  
  def achieve_purpose_current_score_average
    achieve_purpose_current_score / 3
  end

  def achieve_purpose_future_score
    self.answer_211_b + self.answer_212_b + self.answer_213_b
  end
  
  def achieve_purpose_future_score_average
    achieve_purpose_future_score / 3
  end

  def achieve_purpose_gap_score
    achieve_purpose_future_score - achieve_purpose_current_score
  end

  def shared_agreements_current_score
    self.answer_221_a + self.answer_222_a + self.answer_223_a + self.answer_224_a
  end
  
  def shared_agreements_current_score_average
    shared_agreements_current_score / 4
  end

  def shared_agreements_future_score
    self.answer_221_b + self.answer_222_b + self.answer_223_b + self.answer_224_b
  end
  
  def shared_agreements_future_score_average
    shared_agreements_future_score / 4
  end

  def shared_agreements_gap_score
    shared_agreements_future_score - shared_agreements_current_score
  end

  def exit_options_current_score
    self.answer_231_a + self.answer_232_a + self.answer_233_a
  end
  
  def exit_options_current_score_average
    exit_options_current_score / 3
  end

  def exit_options_future_score
    self.answer_231_b + self.answer_232_b + self.answer_233_b
  end
  
  def exit_options_future_score_average
    exit_options_future_score / 3
  end

  def exit_options_gap_score
    exit_options_future_score - exit_options_current_score
  end

  def sum_current_achieve_purpose_shared_agreements_exit_options
    #@sum_current_achieve_purpose_shared_agreements_exit_options ||=
    achieve_purpose_current_score + shared_agreements_current_score + exit_options_current_score
  end

  def sum_future_achieve_purpose_shared_agreements_exit_options
    #@sum_future_achieve_purpose_shared_agreements_exit_options ||=
    achieve_purpose_future_score + shared_agreements_future_score + exit_options_future_score
  end

  def sum_gap_achieve_purpose_shared_agreements_exit_options
    sum_future_achieve_purpose_shared_agreements_exit_options - sum_current_achieve_purpose_shared_agreements_exit_options
  end
  
  def current_dimension_2_average
    self.sum_current_achieve_purpose_shared_agreements_exit_options / 9
  end
  
  def future_dimension_2_average
    self.sum_future_achieve_purpose_shared_agreements_exit_options / 9
  end

  ###### page 3 #####

  def financial_accountability_current_score
    self.answer_311_a + self.answer_312_a + self.answer_313_a
  end
  
  def financial_accountability_current_score_average
    financial_accountability_current_score / 3
  end

  def financial_accountability_future_score
    self.answer_311_b + self.answer_312_b + self.answer_313_b
  end
  
  def financial_accountability_future_score_average
    financial_accountability_future_score / 3
  end

  def financial_accountability_gap_score
    financial_accountability_future_score - financial_accountability_current_score
  end

  def financial_management_current_score
    self.answer_321_a + self.answer_322_a + self.answer_323_a
  end
  
  def financial_management_current_score_average
    financial_management_current_score / 3
  end

  def financial_management_future_score
    self.answer_321_b + self.answer_322_b + self.answer_323_b
  end
  
  def financial_management_future_score_average
    financial_management_future_score / 3
  end

  def financial_management_gap_score
    financial_management_future_score - financial_management_current_score
  end

  def future_generations_current_score
    self.answer_331_a + self.answer_332_a + self.answer_333_a
  end
  
  def future_generations_current_score_average
    future_generations_current_score / 3
  end

  def future_generations_future_score
    self.answer_331_b + self.answer_332_b + self.answer_333_b
  end
  
  def future_generations_future_score_average
    future_generations_future_score / 3
  end

  def future_generations_gap_score
    future_generations_future_score - future_generations_current_score
  end

  def sum_current_financial_accountability_financial_management_future_generations
    financial_accountability_current_score + financial_management_current_score + future_generations_current_score
  end

  def sum_future_financial_accountability_financial_management_future_generations
    financial_accountability_future_score + financial_management_future_score + future_generations_future_score
  end

  def sum_gap_financial_accountability_financial_management_future_generations
    sum_future_financial_accountability_financial_management_future_generations - sum_current_financial_accountability_financial_management_future_generations
  end
  
  def current_dimension_3_average
    self.sum_current_financial_accountability_financial_management_future_generations / 9
  end
  
  def future_dimension_3_average
    self.sum_future_financial_accountability_financial_management_future_generations / 9
  end

  ###### page 4 #####

  def leadership_transition_current_score
    self.answer_411_a + self.answer_412_a + self.answer_413_a
  end
  
  def leadership_transition_current_score_average
    leadership_transition_current_score / 3
  end

  def leadership_transition_future_score
    self.answer_411_b + self.answer_412_b + self.answer_413_b
  end
  
  def leadership_transition_future_score_average
    leadership_transition_future_score / 3
  end

  def leadership_transition_gap_score
    leadership_transition_future_score - leadership_transition_current_score
  end

  def next_gen_leader_current_score
    self.answer_421_a + self.answer_422_a + self.answer_423_a
  end
  
  def next_gen_leader_current_score_average
    next_gen_leader_current_score / 3
  end

  def next_gen_leader_future_score
    self.answer_421_b + self.answer_422_b + self.answer_423_b
  end
  
  def next_gen_leader_future_score_average
    next_gen_leader_future_score / 3
  end

  def next_gen_leader_gap_score
    next_gen_leader_future_score - next_gen_leader_current_score
  end

  def financial_stewardship_current_score
    self.answer_431_a + self.answer_432_a + self.answer_433_a
  end
  
  def financial_stewardship_current_score_average
    financial_stewardship_current_score / 3
  end

  def financial_stewardship_future_score
    self.answer_431_b + self.answer_432_b + self.answer_433_b
  end
  
  def financial_stewardship_future_score_average
    financial_stewardship_future_score / 3
  end

  def financial_stewardship_gap_score
    financial_stewardship_future_score - financial_stewardship_current_score
  end

  def personal_fulfillment_current_score
    self.answer_441_a + self.answer_442_a + self.answer_443_a
  end
  
  def personal_fulfillment_current_score_average
    personal_fulfillment_current_score / 3
  end

  def personal_fulfillment_future_score
    self.answer_441_b + self.answer_442_b + self.answer_443_b
  end
  
  def personal_fulfillment_future_score_average
    personal_fulfillment_future_score / 3
  end

  def personal_fulfillment_gap_score
    personal_fulfillment_future_score - personal_fulfillment_current_score
  end

  def sum_current_leadership_transition_next_gen_leader_financial_stewardship_personal_fulfillment
    leadership_transition_current_score + next_gen_leader_current_score + financial_stewardship_current_score + personal_fulfillment_current_score
  end

  def sum_future_leadership_transition_next_gen_leader_financial_stewardship_personal_fulfillment
    leadership_transition_future_score + next_gen_leader_future_score + financial_stewardship_future_score + personal_fulfillment_future_score
  end

  def sum_gap_leadership_transition_next_gen_leader_financial_stewardship_personal_fulfillment
    sum_future_leadership_transition_next_gen_leader_financial_stewardship_personal_fulfillment - sum_current_leadership_transition_next_gen_leader_financial_stewardship_personal_fulfillment
  end
  
  def current_dimension_4_average
    self.sum_current_leadership_transition_next_gen_leader_financial_stewardship_personal_fulfillment / 12
  end
  
  def future_dimension_4_average
    self.sum_future_leadership_transition_next_gen_leader_financial_stewardship_personal_fulfillment / 12
  end

  private

  # pops the last element of the reg exp element array
  # it should be either "current" or "future"
  def extract_current_or_future_option!(array)
   array.shift
  end
end