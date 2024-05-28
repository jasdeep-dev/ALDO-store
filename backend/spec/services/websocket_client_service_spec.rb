# frozen_string_literal: true

require 'rails_helper'
require_relative '../../app/services/websocket_client_service'
require_relative '../../app/services/inventory_update_service'

RSpec.describe WebSocketClientService, type: :service do
  let(:url) { 'ws://testsocket' }
  let(:batch_size) { 2 }
  let(:batch_interval) { 1 }
  let(:service) { WebSocketClientService.new(url, batch_size, batch_interval) }

  before do
    allow(Faye::WebSocket::Client).to receive(:new).and_return(double('WebSocket', on: nil))
    Thread.new { EventMachine.run }
    sleep(0.1) # Ensure EventMachine is running
  end

  after do
    EventMachine.stop if EventMachine.reactor_running?
  end

  describe '#start' do
    it 'connects to the WebSocket server' do
      expect(Faye::WebSocket::Client).to receive(:new).with(url)
      service.start
    end
  end

  describe '#handle_message' do
    let(:message) { { 'store' => 'Test Store', 'model' => 'Test Model', 'inventory' => 20 }.to_json }

    it 'adds the message to the batch' do
      expect { service.send(:handle_message, message) }.to change {
                                                             service.instance_variable_get(:@updates_batch).size
                                                           }.by(1)
    end
  end

  describe '#process_batch' do
    let(:batch) do
      [
        { 'store' => 'Test Store', 'model' => 'Test Model', 'inventory' => 20 }
      ]
    end

    before do
      service.instance_variable_set(:@updates_batch, batch)
      allow_any_instance_of(InventoryUpdateService).to receive(:perform)
    end

    it 'processes the batch using InventoryUpdateService' do
      expect_any_instance_of(InventoryUpdateService).to receive(:perform)
      service.send(:process_batch)
    end

    it 'clears the batch after processing' do
      service.send(:process_batch)
      expect(service.instance_variable_get(:@updates_batch)).to be_empty
    end
  end
end
