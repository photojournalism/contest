class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :street, :string
    add_column :users, :city, :string
    add_column :users, :state_id, :integer
    add_column :users, :zip, :string
    add_column :users, :country_id, :integer
    add_column :users, :day_phone, :string
    add_column :users, :evening_phone, :string
    add_column :users, :employer, :string
  end
end
