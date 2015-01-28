class AddCartToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :cart, index: true
  end
end
