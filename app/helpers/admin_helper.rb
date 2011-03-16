module AdminHelper
  def survey_answer_attributes_for_excel(display_headers, survey_answer = nil)
    html_elements = "<tr>"
    (1..4).each do |part|
      (1..4).each do |section|
        if section == 4 && !(part == 1 || part == 4)
          next
        end
        if part == 2 and section == 2
          total_parts = 4
        else
          total_parts = 3
        end
        (1..total_parts).each do |question|
          attribute_name_a = "answer_#{part}#{section}#{question}_a"
          attribute_name_b = "answer_#{part}#{section}#{question}_b"
          if display_headers
            html_elements << "<td>#{attribute_name_a}</td>"
            html_elements << "<td>#{attribute_name_b}</td>"
          else
            html_elements << "<td>#{number_with_precision(survey_answer[attribute_name_a], :precision=>2)}</td>"
            html_elements << "<td>#{number_with_precision(survey_answer[attribute_name_b], :precision=>2)}</td>"
          end
        end
      end
    end
    html_elements << "</tr>"
  end
end
