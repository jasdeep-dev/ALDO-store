# frozen_string_literal: true

class Inventory < ApplicationRecord
  belongs_to :store
  belongs_to :shoe_model

  validates :store, presence: true
  validates :shoe_model, presence: true
  validates :inventory, presence: true, numericality: { only_integer: true }
end
