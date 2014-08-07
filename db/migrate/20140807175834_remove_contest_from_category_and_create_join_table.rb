class RemoveContestFromCategoryAndCreateJoinTable < ActiveRecord::Migration
  def change
    remove_column :categories, :contest_id

    create_table :categories_contests, id: false do |t|
      t.belongs_to :category
      t.belongs_to :contest
    end
  end
end
