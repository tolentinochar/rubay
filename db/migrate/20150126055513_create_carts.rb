class CreateCarts < ActiveRecord::Migration
  def change
    create_table :carts do |t|
      t.references :user, index: true
      t.timestamp :checkout_date
      t.decimal :total_price

      t.timestamps
    end
  end
end
