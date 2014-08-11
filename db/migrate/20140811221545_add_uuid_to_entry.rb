class AddUuidToEntry < ActiveRecord::Migration
  def change
    add_column :entries, :uuid, :string
  end
end
