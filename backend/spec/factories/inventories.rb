# frozen_string_literal: true

FactoryBot.define do
  factory :inventory do
    store
    shoe_model
    inventory { Faker::Number.between(from: 1, to: 100) }
  end
end
