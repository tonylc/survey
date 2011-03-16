class CreateSurveys < ActiveRecord::Migration
  def self.up
    create_table :surveys do |t|
      t.integer :user_id, :null => false
      t.boolean :page_1_complete, :null => false, :default => false
      t.boolean :page_2_complete, :null => false, :default => false
      t.boolean :page_3_complete, :null => false, :default => false
      t.boolean :page_4_complete, :null => false, :default => false

      t.timestamps
    end

  end

  def self.down
    drop_table :surveys
  end
end
