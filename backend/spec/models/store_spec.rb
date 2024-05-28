# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Store, type: :model do
  it { should have_many(:inventories).dependent(:delete_all) }
  it { should have_many(:shoe_models).through(:inventories) }
  it { should validate_presence_of(:name) }

  describe 'validations' do
    before do
      create(:store, name: 'Existing Store') # Create a valid store record to test uniqueness validation
    end

    it { should validate_uniqueness_of(:name).case_insensitive }

    it 'is valid with valid attributes' do
      store = build(:store)
      expect(store).to be_valid
    end

    it 'is not valid without a name' do
      store = build(:store, name: nil)
      expect(store).not_to be_valid
    end

    it 'is not valid with a duplicate name' do
      create(:store, name: 'Unique Store')
      store = build(:store, name: 'Unique Store')
      expect(store).not_to be_valid
    end
  end

  describe 'associations' do
    it 'has many inventories' do
      store = create(:store)
      shoe_model = create(:shoe_model)
      inventory = create(:inventory, store:, shoe_model:)
      expect(store.inventories).to include(inventory)
    end

    it 'has many shoe models through inventories' do
      store = create(:store)
      shoe_model = create(:shoe_model)
      create(:inventory, store:, shoe_model:)
      expect(store.shoe_models).to include(shoe_model)
    end
  end

  describe 'dependent destroy' do
    it 'destroys associated inventories when the store is destroyed' do
      store = create(:store)
      shoe_model = create(:shoe_model)
      create(:inventory, store:, shoe_model:)
      expect { store.destroy }.to change { Inventory.count }.by(-1)
    end
  end
end
