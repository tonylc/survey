class CreateSurveyQuestions < ActiveRecord::Migration
  def self.up
    create_table :survey_questions do |t|
      t.string :short_name, :null => false
      t.text :question, :null => false
      t.integer :page_number, :null => false
    end

    # Part I: Family Legacy and Connection

    # Formulate a clear and compelling family direction
    SurveyQuestion.create(:id => 1, :short_name => "answer_111", :question => "Our family has a clear family mission and purpose statement", :page_number => 1)
    SurveyQuestion.create(:id => 2, :short_name => "answer_112", :question => "Values for the family and its wealth are clearly articulated", :page_number => 2)
    SurveyQuestion.create(:id => 3, :short_name => "answer_113", :question => "Our family has developed a strategic plan for how the family will achieve its purpose over generations", :page_number => 3)
    # Appreciate and enjoy extended family connection
    SurveyQuestion.create(:id => 4, :short_name => "answer_121", :question => "Family stories are solicited, recorded and communicated", :page_number => 4)
    SurveyQuestion.create(:id => 5, :short_name => "answer_122", :question => "There are regular gatherings to recognize and celebrate family milestones", :page_number => 1)
    SurveyQuestion.create(:id => 6, :short_name => "answer_123", :question => "There is parental commitment to engage with young people in their activities and family time", :page_number => 2)
    # Develop paths for family communication
    SurveyQuestion.create(:id => 7, :short_name => "answer_131", :question => "Our family meetings allow for constructive discussion of family  issues and concerns", :page_number => 3)
    SurveyQuestion.create(:id => 8, :short_name => "answer_132", :question => "We maintain connections with family members between meetings via a family website, family newsletter, or other communication modes", :page_number => 4)
    SurveyQuestion.create(:id => 9, :short_name => "answer_133", :question => "We observe practices which facilitate open and constructive discussion of difficult issues", :page_number => 1)
    # Develop family's community and social mission
    SurveyQuestion.create(:id => 10, :short_name => "answer_141", :question => "Family philanthropic mission and values are defined", :page_number => 2)
    SurveyQuestion.create(:id => 11, :short_name => "answer_142", :question => "Family members are encouraged to be active in community and service activities", :page_number => 3)
    SurveyQuestion.create(:id => 12, :short_name => "answer_143", :question => "Opportunities exist for family members to engage in social and community activities together", :page_number => 4)

    # page 2
    SurveyQuestion.create(:id => 13, :short_name => "answer_211", :question => "We conduct regular gatherings of the entire family that combine fun, learning, and discussion of shared concerns", :page_number => 1)
    SurveyQuestion.create(:id => 14, :short_name => "answer_212", :question => "We have a Family Council or equivalent family representative body that meets regularly to deal with family issues", :page_number => 2)
    SurveyQuestion.create(:id => 15, :short_name => "answer_213", :question => "Each major family asset is overseen by a board, trustee or other fiduciary group", :page_number => 3)
    SurveyQuestion.create(:id => 16, :short_name => "answer_221", :question => "We have a Family Constitution and/or by-laws that define how our family operates and makes decisions", :page_number => 4)
    SurveyQuestion.create(:id => 17, :short_name => "answer_222", :question => "Our Family Employment Policy defines guidelines for entry, promotion, and compensation in family ventures", :page_number => 1)
    SurveyQuestion.create(:id => 18, :short_name => "answer_223", :question => "Trust agreements and other estate planning documents are shared and understood by both beneficiaries and trustees", :page_number => 2)
    SurveyQuestion.create(:id => 19, :short_name => "answer_231", :question => "Exit opportunities (e.g. buy-sell agreements, etc.) are provided to family shareholders", :page_number => 3)
    SurveyQuestion.create(:id => 20, :short_name => "answer_232", :question => "There is a policy for individual spending of family wealth", :page_number => 4)
    SurveyQuestion.create(:id => 21, :short_name => "answer_233", :question => "A policy exists to set and meet shareholder desired return on investment", :page_number => 1)

    # page 3
    SurveyQuestion.create(:id => 22, :short_name => "answer_311", :question => "Shareholders receive regular financial reports with explanations of changes and forecasts for future performance", :page_number => 2)
    SurveyQuestion.create(:id => 23, :short_name => "answer_312", :question => "Our family has agreed upon dividend and pay-out policies which balance wealth creation with needs of shareholders", :page_number => 3)
    SurveyQuestion.create(:id => 24, :short_name => "answer_313", :question => "The family has portfolio of assets (operating company, investments, real estate, etc.) to reduce long-term risk", :page_number => 4)
    SurveyQuestion.create(:id => 25, :short_name => "answer_321", :question => "Performance vs forecasts is tracked by multi-year business plans for both operating and capital funds", :page_number => 1)
    SurveyQuestion.create(:id => 26, :short_name => "answer_322", :question => "Regular performance evaluations of family managers based on clear criteria occur and are shared with family  members", :page_number => 2)
    SurveyQuestion.create(:id => 27, :short_name => "answer_323", :question => "We have oversight groups for each family enterprise or asset which provide regular reports to the family", :page_number => 3)
    SurveyQuestion.create(:id => 28, :short_name => "answer_331", :question => "Investment and dividend policies have been adopted by our family to provide for continued growth of capital while permitting pay-outs to shareholders and inheritors", :page_number => 4)
    SurveyQuestion.create(:id => 29, :short_name => "answer_332", :question => "The family policies promote self-determination by young adult members rather than reliance solely on inherited wealth", :page_number => 1)
    SurveyQuestion.create(:id => 30, :short_name => "answer_333", :question => "There are funds available to support approved entrepreneurial initiatives through a family bank, venture fund or similar source", :page_number => 2)

    # page 4
    SurveyQuestion.create(:id => 31, :short_name => "answer_411", :question => "Selection and accountability criteria exist for leadership, fiduciary and management roles in family enterprises", :page_number => 3)
    SurveyQuestion.create(:id => 32, :short_name => "answer_412", :question => "Leadership expectations for next generation family members are clear and pathways are defined for assuming family leadership and governance positions", :page_number => 4)
    SurveyQuestion.create(:id => 33, :short_name => "answer_413", :question => "We hold multi-generational discussion of the criteria for making changes in family holdings and for addressing the leadership needs for our next generation family members", :page_number => 1)
    SurveyQuestion.create(:id => 34, :short_name => "answer_421", :question => "The adult family members actively encourage family-wide education, mentoring, leadership and career development of younger family members", :page_number => 2)
    SurveyQuestion.create(:id => 35, :short_name => "answer_422", :question => "There are explicit methods for selection, assessment and development of family members for leadership positions in the family enterprise", :page_number => 3)
    SurveyQuestion.create(:id => 36, :short_name => "answer_423", :question => "Opportunities exist to develop skills by taking part in family enterprises and activities", :page_number => 4)
    SurveyQuestion.create(:id => 37, :short_name => "answer_431", :question => "We have an education for family members including speakers at family meetings, attending conferences together, financial acumen, family field trips, etc.", :page_number => 1)
    SurveyQuestion.create(:id => 38, :short_name => "answer_432", :question => "We have a program to teach younger members about our family’s history and those of its enterprises (businesses, investments, philanthropies)", :page_number => 2)
    SurveyQuestion.create(:id => 39, :short_name => "answer_433", :question => "Processes appropriate to children's age are used to teach/learn about money and its responsibilities", :page_number => 3)
    SurveyQuestion.create(:id => 40, :short_name => "answer_441", :question => "The family respectful of individual choice and pursuit of lifestyle and career path consistent with the family values", :page_number => 4)
    SurveyQuestion.create(:id => 41, :short_name => "answer_442", :question => "Family members are supported and encouraged to pursue personal education and develop marketable skills", :page_number => 1)
    SurveyQuestion.create(:id => 42, :short_name => "answer_443", :question => "We share and respect the personal goals, achievements and career interests of all family members", :page_number => 2)

  end

  def self.down
    drop_table :survey_questions
  end
end
