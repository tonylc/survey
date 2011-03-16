require 'spec_helper'

describe SurveyHelper do
  it "should convert a number 1-4 to its roman numeral counterpart" do
    helper.convert_dimension_number_to_roman_numeral(1).should == "I"
    helper.convert_dimension_number_to_roman_numeral(2).should == "II"
    helper.convert_dimension_number_to_roman_numeral(3).should == "III"
    helper.convert_dimension_number_to_roman_numeral(4).should == "IV"
  end
end