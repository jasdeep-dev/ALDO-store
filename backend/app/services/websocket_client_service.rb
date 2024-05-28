# frozen_string_literal: true

require 'faye/websocket'
require 'eventmachine'
require 'json'

class WebSocketClientService
  def initialize(url, batch_size, batch_interval)
    @url = url
    @batch_size = batch_size
    @batch_interval = batch_interval
    @updates_batch = []
  end

  def start
    EM.run do
      ws = Faye::WebSocket::Client.new(@url)

      ws.on :open do
        puts 'Connected to WebSocket server'
      end

      ws.on :message do |event|
        handle_message(event.data)
      end

      ws.on :close do |event|
        puts "Connection closed with code: #{event.code}, reason: #{event.reason}"
      end

      ws.on :error do |event|
        puts "Error: #{event.message}"
      end

      EM.add_periodic_timer(@batch_interval) do
        process_batch unless @updates_batch.empty?
      end
    end
  rescue StandardError => e
    puts "Error starting WebSocket client server: #{e.message}"
    puts e.backtrace.join("\n")
  end

  private

  def handle_message(data)
    parsed_data = JSON.parse(data)
    @updates_batch << parsed_data

    puts parsed_data
    process_batch if @updates_batch.size >= @batch_size
  rescue JSON::ParserError => e
    puts "Failed to parse JSON: #{e.message}"
  end

  def process_batch
    InventoryUpdateService.new(@updates_batch).perform
    @updates_batch.clear
  end
end
