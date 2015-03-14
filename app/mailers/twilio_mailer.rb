class TwilioMailer
  attr_reader :client, :from_phone, :to_phone, :notification

  def initialize(notification)
    @notification = notification
    @sid = ENV["twilio_account_sid"]
    @token = ENV["twilio_authtoken"]
    @from_phone = ENV["twilio_phone_number"]
    @to_phone = notification.user.phone_number
    @client = Twilio::REST::Client.new(@sid, @token)
  end

  def send_route_notification
    send_message(route_notification)
  end

  private

  def send_message(message)
    client.messages.create(
      from: from_phone,
      to: to_phone,
      body: message
    )
  end

  def route_notification
    ApplicationController.new.render_to_string(
      :template => 'mailers/sms/route_notification',
      :locals   => {
        routes: notification.routes,
        from:   Location.find(notification.from),
        to:     Location.find(notification.to)
      }
    )
  end
end
