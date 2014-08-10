class CreateContestRules < ActiveRecord::Migration
  def change
    create_table :contest_rules do |t|
      t.string :text

      t.timestamps
    end

    change_table :contests do |t|
      t.references :contest_rules
    end
  end
end
