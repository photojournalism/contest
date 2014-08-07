class CreateFileTypesAndCategories < ActiveRecord::Migration
  def change
    create_table :file_types do |t|
      t.string :name
      t.string :extension

      t.timestamps
    end

    create_table :categories do |t|
      t.string :name
      t.references :contest, index: true
      t.string :description
      t.boolean :active

      t.timestamps
    end

    create_table :file_types_categories, id: false do |t|
      t.belongs_to :file_type
      t.belongs_to :part
    end
  end
end
