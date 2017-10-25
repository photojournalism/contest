class AddParentToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :user, index: true
    add_column :users, :can_parent_others, :boolean, default: false
  end
end