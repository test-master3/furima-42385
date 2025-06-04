# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :email,              null: false, default: "", limit: 191
      t.string :encrypted_password, null: false, default: ""
      t.string :nickname, null: false
      t.text :last_name, null: false
      t.text :first_name, null: false
      t.text :last_name_kana, null: false
      t.text :first_name_kana, null: false
      t.date :birthday, null: false
      t.string   :reset_password_token, limit: 191
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at

      t.timestamps null: false
    end
    
    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
  end
end
