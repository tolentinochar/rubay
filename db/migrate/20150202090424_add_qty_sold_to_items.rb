class AddQtySoldToItems < ActiveRecord::Migration
  def change
    add_column :items, :qty_sold, :integer
  end
end
