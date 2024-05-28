# frozen_string_literal: true

class CreateInventories < ActiveRecord::Migration[7.1]
  def up
    return if table_exists?(:inventories)

    create_table :inventories do |t|
      t.references :store,           null: false, foreign_key: true
      # t.string     :store_name,      null: false

      t.references :shoe_model,      null: false, foreign_key: true
      # t.string     :shoe_model_name, null: false

      t.integer    :inventory,       null: false, default: 0

      t.timestamps
    end

    add_index :inventories, %i[store_id shoe_model_id], unique: true
  end

  def down
    drop_table :inventories if table_exists?(:inventories)
  end
end
