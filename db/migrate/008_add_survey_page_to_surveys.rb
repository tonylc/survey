class AddSurveyPageToSurveys < ActiveRecord::Migration
  def self.up
    add_column :surveys, :page_complete, :integer, :default => 0

    surveys = Survey.find(:all)
    Survey.transaction do
      # if something fails, don't remove the column
      surveys.each do |survey|
        if survey.page_4_complete
          survey.page_complete = 4
        elsif survey.page_3_complete
          survey.page_complete = 3
        elsif survey.page_2_complete
          survey.page_complete = 2
        elsif survey.page_1_complete
          survey.page_complete = 1
        end
        survey.save
      end

      remove_column :surveys, :page_1_complete
      remove_column :surveys, :page_2_complete
      remove_column :surveys, :page_3_complete
      remove_column :surveys, :page_4_complete
    end
  end

  def self.down
    add_column :surveys, :page_1_complete, :boolean, :null => false, :default => false
    add_column :surveys, :page_2_complete, :boolean, :null => false, :default => false
    add_column :surveys, :page_3_complete, :boolean, :null => false, :default => false
    add_column :surveys, :page_4_complete, :boolean, :null => false, :default => false

    surveys = Survey.find(:all)
    Survey.transaction do
      # if something fails, don't remove the column
      surveys.each do |survey|
        num = survey.page_complete

        num.downto(1) { |i|
          survey["page_#{i}_complete"] = true
        }
        survey.save
      end

      remove_column :surveys, :page_complete
    end
  end
end
