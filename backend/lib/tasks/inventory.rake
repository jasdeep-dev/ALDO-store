# frozen_string_literal: true

namespace :inventory do
  desc 'Run the WebSocket client server with batch processing'
  task start: :environment do
    puts 'Starting WebSocket client server...'

    # Require the service files explicitly
    require_relative '../../app/services/websocket_client_service'
    require_relative '../../app/services/inventory_update_service'

    url = ENV['SOCKET_URL']
    batch_size = 10
    batch_interval = 10 # seconds

    WebSocketClientService.new(url, batch_size, batch_interval).start
  rescue StandardError => e
    puts "Error starting WebSocket client server: #{e.message}"
    puts e.backtrace.join("\n")
  end
end
