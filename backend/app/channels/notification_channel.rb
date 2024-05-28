# frozen_string_literal: true

class NotificationChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'notification_channel'
    ActionCable.server.broadcast('notification_channel', { message: 'Subscribed to Notifiation channel' })
  end

  def unsubscribed; end
end
