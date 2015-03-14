class SendNotification
  attr_reader :notification

  def initialize(notification)
    @notification = notification
  end

  def call
    case state = notification.aasm.current_state
    when :to_send_route_notification
      TwilioMailer.new(notification).send_route_notification
    else
    end

    notification.save
  end
end
