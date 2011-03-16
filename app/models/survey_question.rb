class SurveyQuestion < ActiveRecord::Base

  validates_numericality_of :page_number, :only_integer => true, :less_than_or_equal_to => APP_CONFIG["number_of_pages"], :greater_than => 0

  # page 1

  def self.answer_111
    @@answer_111 ||= self.find_by_short_name("answer_111")
  end

  def self.answer_112
    @@answer_112 ||= self.find_by_short_name("answer_112")
  end

  def self.answer_113
    @@answer_113 ||= self.find_by_short_name("answer_113")
  end

  def self.answer_121
    @@answer_121 ||= self.find_by_short_name("answer_121")
  end

  def self.answer_122
    @@answer_122 ||= self.find_by_short_name("answer_122")
  end

  def self.answer_123
    @@answer_123 ||= self.find_by_short_name("answer_123")
  end

  def self.answer_131
    @@answer_131 ||= self.find_by_short_name("answer_131")
  end

  def self.answer_132
    @@answer_132 ||= self.find_by_short_name("answer_132")
  end

  def self.answer_133
    @@answer_133 ||= self.find_by_short_name("answer_133")
  end

  def self.answer_141
    @@answer_141 ||= self.find_by_short_name("answer_141")
  end

  def self.answer_142
    @@answer_142 ||= self.find_by_short_name("answer_142")
  end

  def self.answer_143
    @@answer_143 ||= self.find_by_short_name("answer_143")
  end

  # page 2

  def self.answer_211
    @@answer_211 ||= self.find_by_short_name("answer_211")
  end

  def self.answer_212
    @@answer_212 ||= self.find_by_short_name("answer_212")
  end

  def self.answer_213
    @@answer_213 ||= self.find_by_short_name("answer_213")
  end

  def self.answer_221
    @@answer_221 ||= self.find_by_short_name("answer_221")
  end

  def self.answer_222
    @@answer_222 ||= self.find_by_short_name("answer_222")
  end

  def self.answer_223
    @@answer_223 ||= self.find_by_short_name("answer_223")
  end

  def self.answer_231
    @@answer_231 ||= self.find_by_short_name("answer_231")
  end

  def self.answer_232
    @@answer_232 ||= self.find_by_short_name("answer_232")
  end

  def self.answer_233
    @@answer_233 ||= self.find_by_short_name("answer_233")
  end

  # page 3

    def self.answer_311
    @@answer_311 ||= self.find_by_short_name("answer_311")
  end

  def self.answer_312
    @@answer_312 ||= self.find_by_short_name("answer_312")
  end

  def self.answer_313
    @@answer_313 ||= self.find_by_short_name("answer_313")
  end

  def self.answer_321
    @@answer_321 ||= self.find_by_short_name("answer_321")
  end

  def self.answer_322
    @@answer_322 ||= self.find_by_short_name("answer_322")
  end

  def self.answer_323
    @@answer_323 ||= self.find_by_short_name("answer_323")
  end

  def self.answer_331
    @@answer_331 ||= self.find_by_short_name("answer_331")
  end

  def self.answer_332
    @@answer_332 ||= self.find_by_short_name("answer_332")
  end

  def self.answer_333
    @@answer_333 ||= self.find_by_short_name("answer_333")
  end

  # page 4

  def self.answer_411
    @@answer_411 ||= self.find_by_short_name("answer_411")
  end

  def self.answer_412
    @@answer_412 ||= self.find_by_short_name("answer_412")
  end

  def self.answer_413
    @@answer_413 ||= self.find_by_short_name("answer_413")
  end

  def self.answer_421
    @@answer_421 ||= self.find_by_short_name("answer_421")
  end

  def self.answer_422
    @@answer_422 ||= self.find_by_short_name("answer_422")
  end

  def self.answer_423
    @@answer_423 ||= self.find_by_short_name("answer_423")
  end

  def self.answer_431
    @@answer_431 ||= self.find_by_short_name("answer_431")
  end

  def self.answer_432
    @@answer_432 ||= self.find_by_short_name("answer_432")
  end

  def self.answer_433
    @@answer_433 ||= self.find_by_short_name("answer_433")
  end

  def self.answer_441
    @@answer_441 ||= self.find_by_short_name("answer_441")
  end

  def self.answer_442
    @@answer_442 ||= self.find_by_short_name("answer_442")
  end

  def self.answer_443
    @@answer_443 ||= self.find_by_short_name("answer_443")
  end
  
end