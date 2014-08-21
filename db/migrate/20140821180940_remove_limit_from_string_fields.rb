class RemoveLimitFromStringFields < ActiveRecord::Migration
  def change
    change_column :categories, :description, :text, :limit => nil
    change_column :category_types, :description, :text, :limit => nil
    change_column :contest_rules, :text, :text, :limit => nil
  end
end
