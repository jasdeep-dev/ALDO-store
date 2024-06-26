# frozen_string_literal: true

FactoryBot.define do
  factory :store do
    sequence(:name) { |n| "Store #{n}" }
  end
end
