class ConvertSurveyAnswerFromIntToFloat < ActiveRecord::Migration
  def self.up
    sa = SurveyAnswer.new
    sa.attributes.each_key do |attribute_name|
      if attribute_name.include?("answer")
        change_column(:survey_answers, attribute_name.to_sym, :float)
      end
    end
  end

  def self.down
    sa = SurveyAnswer.new
    sa.attributes.each_key do |attribute_name|
      if attribute_name.include?("answer")
        change_column(:survey_answers, attribute_name.to_sym, :integer)
      end
    end
  end
end