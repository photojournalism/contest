class CreateContests < ActiveRecord::Migration
  def change
    create_table :contests do |t|
      t.integer :year
      t.string :name
      t.datetime :open_date
      t.datetime :close_date

      t.timestamps
    end
  end
end
