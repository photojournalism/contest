class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.references :category, index: true
      t.references :user, index: true
      t.boolean :judged
      t.references :place, index: true

      t.timestamps
    end
  end
end
