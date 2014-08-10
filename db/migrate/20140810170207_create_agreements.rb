class CreateAgreements < ActiveRecord::Migration
  def change
    create_table :agreements do |t|
      t.references :user, index: true
      t.references :contest, index: true

      t.timestamps
    end
  end
end
