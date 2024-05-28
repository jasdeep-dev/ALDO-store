# frozen_string_literal: true

class Store < ApplicationRecord
  has_many :inventories, dependent: :delete_all
  has_many :shoe_models, through: :inventories
  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
