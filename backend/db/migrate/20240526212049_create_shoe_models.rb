# frozen_string_literal: true

class CreateShoeModels < ActiveRecord::Migration[7.1]
  def up
    return if table_exists?(:shoe_models)

    create_table :shoe_models do |t|
      t.string     :name,       null: false
      t.decimal    :price,      precision: 10, scale: 2, null: false

      t.timestamps
    end

    add_index :shoe_models, :name, unique: true
  end

  def down
    drop_table :shoe_models if table_exists?(:shoe_models)
  end
end
