class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :filename
      t.string :original_filename
      t.integer :size
      t.string :location
      t.references :entry

      t.timestamps
    end
  end
end
