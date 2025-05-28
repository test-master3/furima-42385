class CreateItems < ActiveRecord::Migration[7.1]
  def change
    create_table :items do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.integer :price, null: false
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false
      t.references :state, null: false
      t.references :delivery_cost, null: false
      t.references :prefecture, null: false
      t.references :delivery_date, null: false
      t.timestamps
    end
  end
end
