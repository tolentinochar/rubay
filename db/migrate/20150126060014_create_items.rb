class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.text :desc
      t.string :img_url
      t.decimal :unit_price
      t.integer :qty

      t.timestamps
    end
  end
end
