# frozen_string_literal: true

class CreateStores < ActiveRecord::Migration[7.1]
  def up
    return if table_exists?(:stores)

    create_table :stores do |t|
      t.string :name, null: false
      t.string :address

      t.timestamps
    end

    add_index :stores, :name, unique: true
  end

  def down
    drop_table :stores if table_exists?(:stores)
  end
end
