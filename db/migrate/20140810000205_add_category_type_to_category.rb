class AddCategoryTypeToCategory < ActiveRecord::Migration
  def change
    add_reference :categories, :category_type, index: true
  end
end
