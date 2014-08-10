class AddUrlAndOrderNumberToEntry < ActiveRecord::Migration
  def change
    add_column :entries, :url, :string
    add_column :entries, :order_number, :string
  end
end
