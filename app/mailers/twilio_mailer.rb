class TwilioMailer
  attr_reader :client, :from_phone, :to_phone, :notification

  def initialize(notification=nil, to_phone=nil, error=nil)
    @notification = notification
    @from_phone   = ENV["twilio_phone_number"]
    @to_phone     = notification.user.phone_number || to_phone
    @token        = ENV["twilio_authtoken"]
    @sid          = ENV["twilio_account_sid"]
    @client       = Twilio::REST::Client.new(@sid, @token)
  end

  def send_route_notification
    send_message(route_notification)
  end

  def send_from_request
    send_message(from_request)
  end

  def send_to_request
    send_message(to_request)
  end

  def send_option_notification(option)
    send_message(option_notification(option))
  end

  def send_invalid_user_notification
    send_message(invalid_user_notification)
  end

  def send_invalid_location_notification
    send_message(invalid_location_notification)
  end

  def send_invalid_option_notification
    send_message(invalid_option_notification)
  end

  def send_invalid_notification
    send_message(invalid_notification)
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
        }
      )
    end

    def option_notification(option)
      ApplicationController.new.render_to_string(
        :template => 'mailers/sms/option_notification',
        :locals   => {
          route:  notification.routes[option-1]
        }
      )
    end

    def from_request
      ApplicationController.new.render_to_string(
        :template => 'mailers/sms/from_request'
      )
    end

    def to_request
      ApplicationController.new.render_to_string(
        :template => 'mailers/sms/to_request'
      )
    end

    def invalid_user_notification
      ApplicationController.new.render_to_string(
        :template => 'mailers/sms/invalid_user_notification'
      )
    end

    def invalid_location_notification
      ApplicationController.new.render_to_string(
        :template => 'mailers/sms/invalid_location_notification'
      )
    end

    def invalid_option_notification
      ApplicationController.new.render_to_string(
        :template => 'mailers/sms/invalid_option_notification'
      )
    end

    def invalid_notification
      ApplicationController.new.render_to_string(
        :template => 'mailers/sms/invalid_notification'
      )
    end
end
