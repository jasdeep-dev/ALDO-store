# frozen_string_literal: true

class ShoeModel < ApplicationRecord
  has_many :inventories, dependent: :delete_all
  has_many :stores, through: :inventories
  validates :price, presence: true, numericality: { greater_than: 0 }

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  def as_json(options = {})
    h = super(options)
    h['price'] = price.to_f
    h
  end
end
