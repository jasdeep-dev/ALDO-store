# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Inventory, type: :model do
  it { should belong_to(:store) }
  it { should belong_to(:shoe_model) }
  it { should validate_presence_of(:store) }
  it { should validate_presence_of(:shoe_model) }
  it { should validate_presence_of(:inventory) }
  it { should validate_numericality_of(:inventory).only_integer }

  describe 'validations' do
    it 'is valid with valid attributes' do
      inventory = build(:inventory)
      expect(inventory).to be_valid
    end

    it 'is not valid without a store' do
      inventory = build(:inventory, store: nil)
      expect(inventory).not_to be_valid
    end

    it 'is not valid without a shoe_model' do
      inventory = build(:inventory, shoe_model: nil)
      expect(inventory).not_to be_valid
    end

    it 'is not valid without an inventory count' do
      inventory = build(:inventory, inventory: nil)
      expect(inventory).not_to be_valid
    end

    it 'is not valid with a non-integer inventory count' do
      inventory = build(:inventory, inventory: 1.5)
      expect(inventory).not_to be_valid
    end

    it 'is valid with an integer inventory count' do
      inventory = build(:inventory, inventory: 10)
      expect(inventory).to be_valid
    end
  end

  describe 'associations' do
    it 'belongs to a store' do
      store = create(:store)
      shoe_model = create(:shoe_model)
      inventory = create(:inventory, store:, shoe_model:)
      expect(inventory.store).to eq(store)
    end

    it 'belongs to a shoe model' do
      store = create(:store)
      shoe_model = create(:shoe_model)
      inventory = create(:inventory, store:, shoe_model:)
      expect(inventory.shoe_model).to eq(shoe_model)
    end
  end
end
