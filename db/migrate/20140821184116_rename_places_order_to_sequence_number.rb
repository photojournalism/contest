class RenamePlacesOrderToSequenceNumber < ActiveRecord::Migration
  def change
    rename_column :places, :order, :sequence_number
  end
end
