class ReplaceEntryUuidWithHash < ActiveRecord::Migration
  def change
    add_column :entries, :unique_hash, :string
    remove_column :entries, :uuid
  end
end
