# frozen_string_literal: true

# config/initializers/redis.rb
redis_url = if Rails.env.development? || Rails.env.test?
              ENV['REDIS_URL'] || 'redis://localhost:6379/1'
            else
              ENV['REDIS_URL']
            end

ActionCable.server.config.cable = { adapter: 'redis', url: redis_url }
