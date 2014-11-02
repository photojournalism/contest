class AddCssClassToPlace < ActiveRecord::Migration
  def change
    add_column :places, :css_class, :string
  end
end
