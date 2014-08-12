class AddContestToEntry < ActiveRecord::Migration
  def change
    add_reference :entries, :contest, index: true
  end
end
