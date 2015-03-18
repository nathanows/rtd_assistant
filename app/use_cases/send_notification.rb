class SendNotification
  attr_reader :notification, :option

  def initialize(notification, option=nil)
    @notification = notification
    @option       = option.to_i
  end

  def call
    case notification.aasm.current_state
    when :to_send_route_notification
      TwilioMailer.new(notification).send_route_notification
    when :to_send_from_request
      TwilioMailer.new(notification).send_from_request
    when :to_send_to_request
      TwilioMailer.new(notification).send_to_request
    when :waiting_for_additional_option_requests
      TwilioMailer.new(notification).send_option_notification(option)
    else
      TwilioMailer.new(to_phone: from).send_invalid_notification
    end

    notification.save
  end
end
