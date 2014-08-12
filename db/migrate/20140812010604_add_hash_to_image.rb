class AddHashToImage < ActiveRecord::Migration
  def change
    add_column :images, :unique_hash, :string
  end
end
