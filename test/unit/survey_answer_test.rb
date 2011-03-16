require 'test_helper'
#require File.dirname(__FILE__) + '/../test_helper'

class SurveyAnswerTest < ActiveSupport::TestCase
  fixtures :survey_answers

  def test_survey_answer
    survey_answer = survey_answers(:default)
    assert_equal(6, survey_answer.current_direction_score, "Wrong score")
    assert_equal(3, survey_answer.future_direction_score, "Wrong score")
    assert_equal(7, survey_answer.current_connection_score, "Wrong score")
    assert_equal(9, survey_answer.future_connection_score, "Wrong score")
    assert_equal(6, survey_answer.current_communication_score, "Wrong score")
    assert_equal(3, survey_answer.future_communication_score, "Wrong score")
    assert_equal(3, survey_answer.current_community_score, "Wrong score")
    assert_equal(8, survey_answer.future_community_score, "Wrong score")
    assert_equal(6, survey_answer.current_achieve_purpose_score, "Wrong score")
    assert_equal(5, survey_answer.future_achieve_purpose_score, "Wrong score")
    assert_equal(7, survey_answer.current_shared_agreements_score, "Wrong score")
    assert_equal(8, survey_answer.future_shared_agreements_score, "Wrong score")
    assert_equal(9, survey_answer.current_exit_options_score, "Wrong score")
    assert_equal(4, survey_answer.future_exit_options_score, "Wrong score")
    assert_equal(8, survey_answer.current_financial_accountability_score, "Wrong score")
    assert_equal(7, survey_answer.future_financial_accountability_score, "Wrong score")
    assert_equal(9, survey_answer.current_financial_mangament_score, "Wrong score")
    assert_equal(4, survey_answer.future_financial_mangament_score, "Wrong score")
    assert_equal(5, survey_answer.current_future_generations_score, "Wrong score")
    assert_equal(7, survey_answer.future_future_generations_score, "Wrong score")
    assert_equal(3, survey_answer.current_leadership_transition_score, "Wrong score")
    assert_equal(8, survey_answer.future_leadership_transition_score, "Wrong score")
    assert_equal(7, survey_answer.current_next_gen_leader_score, "Wrong score")
    assert_equal(6, survey_answer.future_next_gen_leader_score, "Wrong score")
    assert_equal(4, survey_answer.current_financial_stewardship_score, "Wrong score")
    assert_equal(4, survey_answer.future_financial_stewardship_score, "Wrong score")
    assert_equal(6, survey_answer.current_personal_fulfillment_score, "Wrong score")
    assert_equal(12, survey_answer.future_personal_fulfillment_score, "Wrong score")
  end
end
