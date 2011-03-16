class CreateSurveyAnswers < ActiveRecord::Migration
  def self.up
    create_table :survey_answers do |t|
      t.integer :survey_id
      t.integer :family_id
      t.integer :answer_111_a
      t.integer :answer_111_b
      t.integer :answer_112_a
      t.integer :answer_112_b
      t.integer :answer_113_a
      t.integer :answer_113_b
      t.integer :answer_121_a
      t.integer :answer_121_b
      t.integer :answer_122_a
      t.integer :answer_122_b
      t.integer :answer_123_a
      t.integer :answer_123_b
      t.integer :answer_131_a
      t.integer :answer_131_b
      t.integer :answer_132_a
      t.integer :answer_132_b
      t.integer :answer_133_a
      t.integer :answer_133_b
      t.integer :answer_141_a
      t.integer :answer_141_b
      t.integer :answer_142_a
      t.integer :answer_142_b
      t.integer :answer_143_a
      t.integer :answer_143_b
      t.integer :answer_211_a
      t.integer :answer_211_b
      t.integer :answer_212_a
      t.integer :answer_212_b
      t.integer :answer_213_a
      t.integer :answer_213_b
      t.integer :answer_221_a
      t.integer :answer_221_b
      t.integer :answer_222_a
      t.integer :answer_222_b
      t.integer :answer_223_a
      t.integer :answer_223_b
      t.integer :answer_231_a
      t.integer :answer_231_b
      t.integer :answer_232_a
      t.integer :answer_232_b
      t.integer :answer_233_a
      t.integer :answer_233_b
      t.integer :answer_311_a
      t.integer :answer_311_b
      t.integer :answer_312_a
      t.integer :answer_312_b
      t.integer :answer_313_a
      t.integer :answer_313_b
      t.integer :answer_321_a
      t.integer :answer_321_b
      t.integer :answer_322_a
      t.integer :answer_322_b
      t.integer :answer_323_a
      t.integer :answer_323_b
      t.integer :answer_331_a
      t.integer :answer_331_b
      t.integer :answer_332_a
      t.integer :answer_332_b
      t.integer :answer_333_a
      t.integer :answer_333_b
      t.integer :answer_411_a
      t.integer :answer_411_b
      t.integer :answer_412_a
      t.integer :answer_412_b
      t.integer :answer_413_a
      t.integer :answer_413_b
      t.integer :answer_421_a
      t.integer :answer_421_b
      t.integer :answer_422_a
      t.integer :answer_422_b
      t.integer :answer_423_a
      t.integer :answer_423_b
      t.integer :answer_431_a
      t.integer :answer_431_b
      t.integer :answer_432_a
      t.integer :answer_432_b
      t.integer :answer_433_a
      t.integer :answer_433_b
      t.integer :answer_441_a
      t.integer :answer_441_b
      t.integer :answer_442_a
      t.integer :answer_442_b
      t.integer :answer_443_a
      t.integer :answer_443_b

      t.timestamps
    end
  end

  def self.down
    drop_table :survey_answers
  end
end
