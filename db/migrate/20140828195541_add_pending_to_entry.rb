class AddPendingToEntry < ActiveRecord::Migration
  def change
    add_column :entries, :pending, :boolean
  end
end
