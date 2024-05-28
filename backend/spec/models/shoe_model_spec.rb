# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShoeModel, type: :model do
  describe 'associations' do
    it { should have_many(:inventories).dependent(:delete_all) }
    it { should have_many(:stores).through(:inventories) }
  end

  describe 'validations' do
    subject { ShoeModel.new(name: 'Test Shoe Model', price: 99.99) }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive }
    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price).is_greater_than(0) }

    it 'is valid with valid attributes' do
      shoe_model = ShoeModel.new(name: 'Test Shoe Model', price: 99.99)
      expect(shoe_model).to be_valid
    end

    it 'is not valid without a name' do
      shoe_model = ShoeModel.new(name: nil, price: 99.99)
      expect(shoe_model).not_to be_valid
    end

    it 'is not valid without a price' do
      shoe_model = ShoeModel.new(name: 'Test Shoe Model', price: nil)
      expect(shoe_model).not_to be_valid
    end

    it 'is not valid with a non-numeric price' do
      shoe_model = ShoeModel.new(name: 'Test Shoe Model', price: 'abc')
      expect(shoe_model).not_to be_valid
    end

    it 'is not valid with a negative price' do
      shoe_model = ShoeModel.new(name: 'Test Shoe Model', price: -10)
      expect(shoe_model).not_to be_valid
    end

    it 'is valid with a decimal price' do
      shoe_model = ShoeModel.new(name: 'Test Shoe Model', price: 99.99)
      expect(shoe_model).to be_valid
    end
  end

  describe '#as_json' do
    it 'returns the price as a float' do
      shoe_model = ShoeModel.new(name: 'Test Shoe Model', price: 99.99)
      expect(shoe_model.as_json['price']).to eq(99.99)
    end
  end
end
