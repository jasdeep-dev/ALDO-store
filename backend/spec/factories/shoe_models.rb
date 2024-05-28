# frozen_string_literal: true

FactoryBot.define do
  factory :shoe_model do
    sequence(:name) { |n| "Model #{n}" }
    price { Faker::Commerce.price(range: 50.0..150.0) }
  end
end
