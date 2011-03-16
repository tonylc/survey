class CreateFamilies < ActiveRecord::Migration
  def self.up
    create_table :families, :force => true do |t|
      t.string :mailing_address
      t.string :city
      t.string :state,                     :limit => 2
      t.string :zip_code,                  :limit => 5
      t.string :phone_number,              :limit => 10
      t.integer :num_users,                :null => :false
      t.string :business_name,             :null => :false
      t.integer :num_generations

      t.timestamps
    end
  end

  def self.down
    drop_table :families
  end
end
