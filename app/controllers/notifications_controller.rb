class NotificationsController < ApplicationController

  skip_before_action :verify_authenticity_token

  def notify
    client = Twilio::REST::Client.new ENV['twilio_account_sid'], ENV['twilio_authtoken']
    message = client.messages.create from: '+17207091114', to: '+15037087739', body: 'Learning to send SMS you are.'
    render plain: message.status
  end
end
