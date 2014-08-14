class AddCaptionAndImageNumberToImage < ActiveRecord::Migration
  def change
    add_column :images, :caption, :string
    add_column :images, :number, :integer
  end
end
