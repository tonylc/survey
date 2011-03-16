class AddSurveyAnswer < ActiveRecord::Migration
  def self.up
    add_column :survey_answers, :answer_224_a, :float
    add_column :survey_answers, :answer_224_b, :float
    
    SurveyQuestion.create!(:short_name => "answer_224", :question => "We educate beneficiaries and trustees about trust agreements and other estate planning documents that govern the transfer of family assets.", :page_number => 1)
  end

  def self.down
    remove_column :survey_answers, :answer_224_a
    remove_column :survey_answers, :answer_224_b
    
    SurveyQuestion.find_by_short_name("answer_224").destroy
  end
end
