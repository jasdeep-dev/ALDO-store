# spec/channels/chat_channel_spec.rb
require 'rails_helper'

RSpec.describe NotificationChannel, type: :channel do
  it 'subscribes to a stream when room id is provided' do
    subscribe
    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_from('notification_channel')
    expect{subscribe}.to have_broadcasted_to('notification_channel').with(message: 'Subscribed to Notifiation channel')
  end

  it 'unsubscribes from the stream' do
    subscribe
    expect(subscription).to be_confirmed

    unsubscribe
    expect(subscription).to_not have_streams
  end
end
