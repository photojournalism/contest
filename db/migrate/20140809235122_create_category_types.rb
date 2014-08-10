class CreateCategoryTypes < ActiveRecord::Migration
  def change
    drop_table :categories_file_types

    create_table :category_types do |t|
      t.string :name
      t.string :description
      t.integer :minimum_files
      t.integer :maximum_files
      t.boolean :has_url
      t.boolean :active

      t.timestamps
    end

    create_table :category_types_file_types do |t|
      t.belongs_to :category_types
      t.belongs_to :file_types
    end
  end
end
