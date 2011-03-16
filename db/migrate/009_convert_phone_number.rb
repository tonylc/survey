class ConvertPhoneNumber < ActiveRecord::Migration
  def self.up
    change_column :families, :phone_number, :string, :limit => 20
  end

  def self.down
    change_column :families, :phone_number, :string, :limit => 10
  end
end
