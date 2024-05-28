# frozen_string_literal: true

# simple_websocket_server.rb
require 'em-websocket'

EM.run do
  EM::WebSocket.start(host: '0.0.0.0', port: 9000) do |ws|
    ws.onopen do |_handshake|
      puts 'WebSocket connection open'
      ws.send({ message: 'Hello from WebSocket server!' }.to_json)
    end

    ws.onclose do
      puts 'Connection closed'
    end

    ws.onmessage do |msg|
      puts "Received message: #{msg}"
      ws.send "Pong: #{msg}"
    end
  end
end
