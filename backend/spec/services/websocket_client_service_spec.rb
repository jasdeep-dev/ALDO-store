# frozen_string_literal: true

require 'rails_helper'
require 'faye/websocket'
require 'eventmachine'

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

    it 'handles StandardError during start' do
      allow(EM).to receive(:run).and_raise(StandardError.new('Test error'))

      expect(service).to receive(:puts).with('Error starting WebSocket client server: Test error')
      expect(service).to receive(:puts).with(a_string_including('web_socket_client_service_spec.rb'))

      service.start
    end

    it 'prints connected message on open event' do
      EM.run do
        ws = instance_double(Faye::WebSocket::Client)
        allow(Faye::WebSocket::Client).to receive(:new).and_return(ws)

        allow(ws).to receive(:on).with(:open).and_yield
        allow(ws).to receive(:on).with(:message)
        allow(ws).to receive(:on).with(:close)
        allow(ws).to receive(:on).with(:error)
        expect(service).to receive(:puts).with('Connected to WebSocket server')

        service.start
        EM.stop
      end
    end

    it 'handles message events' do
      EM.run do
        ws = instance_double(Faye::WebSocket::Client)
        allow(Faye::WebSocket::Client).to receive(:new).and_return(ws)

        data = { 'store' => 'Store 1', 'model' => 'Model 1', 'inventory' => 50 }.to_json
        allow(ws).to receive(:on).with(:open)
        allow(ws).to receive(:on).with(:message).and_yield(double(data:))
        allow(ws).to receive(:on).with(:close)
        allow(ws).to receive(:on).with(:error)
        expect(service).to receive(:handle_message).with(data)

        service.start
        EM.stop
      end
    end

    it 'prints close message on close event' do
      EM.run do
        ws = instance_double(Faye::WebSocket::Client)
        allow(Faye::WebSocket::Client).to receive(:new).and_return(ws)

        allow(ws).to receive(:on).with(:open)
        allow(ws).to receive(:on).with(:message)
        allow(ws).to receive(:on).with(:close).and_yield(double(code: 1000, reason: ''))
        allow(ws).to receive(:on).with(:error)
        expect(service).to receive(:puts).with('Connection closed with code: 1000, reason: ')

        service.start
        EM.stop
      end
    end

    it 'prints error message on error event' do
      EM.run do
        ws = instance_double(Faye::WebSocket::Client)
        allow(Faye::WebSocket::Client).to receive(:new).and_return(ws)

        allow(ws).to receive(:on).with(:open)
        allow(ws).to receive(:on).with(:message)
        allow(ws).to receive(:on).with(:close)
        allow(ws).to receive(:on).with(:error).and_yield(double(message: 'Test error'))
        expect(service).to receive(:puts).with('Error: Test error')

        service.start
        EM.stop
      end
    end

    it 'processes batch periodically' do
      EM.run do
        allow(service).to receive(:process_batch)

        # Start the service
        service.start

        # Add some data to the updates_batch
        service.instance_variable_set(:@updates_batch,
                                      [{ 'store' => 'Store 1', 'model' => 'Model 1', 'inventory' => 50 }])

        # Wait for the periodic timer to trigger
        EM.add_timer(1.5) do # Adjust the timer to ensure it runs after the batch interval
          expect(service).to have_received(:process_batch).at_least(:once)
          EM.stop
        end
      end
    end

    it 'handles StandardError during start' do
      allow(EM).to receive(:run).and_raise(StandardError.new('Test error'))

      expect(service).to receive(:puts).with('Error starting WebSocket client server: Test error')
      expect(service).to receive(:puts).with(a_string_including('web_socket_client_service_spec.rb'))

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

    it 'parses JSON message and adds to batch' do
      data = { 'store' => 'Store 1', 'model' => 'Model 1', 'inventory' => 50 }.to_json
      parsed_data = JSON.parse(data)
      expect(service).to receive(:puts).with(parsed_data)

      service.send(:handle_message, data)

      updates_batch = service.instance_variable_get(:@updates_batch)
      expect(updates_batch.size).to eq(1)
      expect(updates_batch).to include(parsed_data)
    end

    it 'handles JSON::ParserError' do
      invalid_data = 'invalid json'
      error_message = 'unexpected token at \'invalid json\''

      expect(service).to receive(:puts).with("Failed to parse JSON: #{error_message}")

      service.send(:handle_message, invalid_data)
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
