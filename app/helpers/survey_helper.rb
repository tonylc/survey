module SurveyHelper
  def convert_dimension_number_to_roman_numeral(dimension_number)
    case dimension_number
      when 4 then "IV"
      else "I" * dimension_number
    end
  end
  
  def set_dimension_title(dimension_title, score_type = :current)
    if score_type == :current
  		dimension_title << " &mdash; Current Assessment"
  	else
  		dimension_title << " &mdash; Future Importance"
  	end
  	
  	dimension_title
  end
  
  def generate_question_response(attribute_string, val_selected=nil)
    # ugly hack, but it keeps validation highlights in one row
    html_elements = "<table><tr><td>"
    html_elements << generate_radio_button(attribute_string, "0", val_selected)
    html_elements << "</td><td>0</td><td>"
    html_elements << generate_radio_button(attribute_string, "1", val_selected)
    html_elements << "</td><td>1</td><td>"
    html_elements << generate_radio_button(attribute_string, "2", val_selected)
    html_elements << "</td><td>2</td><td>"
    html_elements << generate_radio_button(attribute_string, "3", val_selected)
    html_elements << "</td><td>3</td><td>"
    html_elements << generate_radio_button(attribute_string, "4", val_selected)
    html_elements << "</td><td>4</td><td>"
    html_elements << generate_radio_button(attribute_string, "0", val_selected)
    html_elements << "</td><td>DK</td></tr></table>"
  end

  def generate_radio_button(attribute_string, value, val_selected)
    radio_button = "<input type=\"radio\" value=\""
    radio_button << value.to_s
    radio_button << "\" name=\"survey_answer["
    radio_button << attribute_string
    radio_button << "]\" id=\"survey_answer_"
    radio_button << attribute_string
    radio_button << "_"
    radio_button << value
    if val_selected.nil? || value.to_i != val_selected.to_i
      radio_button << "\"/>"
    else
      radio_button << "\" checked=\"checked\"/>"     
    end
  end

  def options_for_survey_response
    {"1" => 1.0, "2" => 2.0, "3" => 3.0, "4" => 4.0, "5" => 5.0}
  end

  def results_part_2_view(float_value)
    number_with_precision(float_value, :precision => 2)
  end
  
  def family_member_label(index)
    if index == 0
      "You"
    else
      "FM#{index}"
    end
  end
  
  def generate_x_labels_for_family(num = 1)    
    x_axis_label = ""
    (1..num).each_with_index do |val, index|
        x_axis_label << "\"#{family_member_label(index)}\"," 
    end
    x_axis_label.chop
  end
  
  def generate_data_series_for_family(family_answers, dimension_num, score_type = :current)
    data_series = []
    family_answers.each_with_index do |answer, index|
      data_series << "[#{index}, #{answer.method("#{score_type}_dimension_#{dimension_num}_average").call.round_with_precision(2)}]"
    end
    "[#{data_series.join(",")}]"
  end
  
  def generate_x_axis(array)
    x_axis_label = ""
    (0..array.length).each do |index|
      x_axis_label << "#{index},"
    end
    
    x_axis_label.chop
  end
  
  def generate_graph_score(array)
    data_set = "["
    (1..array.length).each_with_index do |index_title, index|
      data_set << "[#{index_title}, #{array[index]}],"
    end
    # remove last ','
    data_set = data_set.chop
    data_set << "]"
  end
  
  def generate_js_attribute_section_names(array)
    section_name_array = "['',"
    array.each do |section_name|
      section_name_array << "\'#{section_name}\',"
    end
    # remove last ','
    section_name_array = section_name_array.chop
    section_name_array << "]"
  end
  
  # first one is always yourself
  def generate_google_graph_url(family_answers, dimension_num)
    num_points = family_answers.size
    graph_url = "http://chart.apis.google.com/chart?cht=s"
    # 600 x 400 size
    graph_url << "&chs=600x400"
    # x,y coordinates
    graph_url << "&chxt=x,y"
    graph_url << "&chxr=0|1,0,4,0.5"
    # graph labels
    graph_url << "&chxl=0:|#{num_points} Family Members"
    # graph_url << "&chxl=0:|You"
    # if num_points > 1
    #   graph_url << "|Family Members 1"
    #   graph_url << "-#{num_points-1}" if num_points > 2
    # end
    graph_url << "&chxp=0,50"
    # graph_url << ",40" if num_points > 1
    # legend
    graph_url << "&chdl=Current|Future"
    # series color
    graph_url << "&chco=FF0000|0000FF"
    
    x_data_series = []
    y_data_series = []
    z_data_series = []
    
    #your_series = family_answers.shift
    family_answers.each_with_index do |answer, index|
      x_data_series << (index + 1) * 2 + 30
      x_data_series << (index + 1) * 2 + 30
      
      y_data_series << answer.method("current_dimension_#{dimension_num}_average").call.round_with_precision(2)*25
      y_data_series << answer.method("future_dimension_#{dimension_num}_average").call.round_with_precision(2)*25
      
      if index == 0        
        z_data_series << 120
        z_data_series << 120
      else
        z_data_series << 75
        z_data_series << 75
      end
    end
    
    graph_url << "&chd=t:#{x_data_series.join(",")}|#{y_data_series.join(",")}|#{z_data_series.join(",")}"
    graph_url
    #http://chart.apis.google.com/chart?cht=s&chd=t:10,10,10,15,20|10,20,30,15,20|10,50,100&chs=600x400&chxt=x,y&chxl=0:|me|fm1|fm2
  end
end
