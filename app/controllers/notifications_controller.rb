class NotificationsController < ApplicationController

  def create
    @notification = Notification.create(notification_params)
    redirect_to dashboard_path
  end

  def receive_text
    if SMSValidator.new(params["Body"], params["From"]).user?
      NotificationRouter.new(params["Body"], params["From"]).call
      head :ok
    else
      TwilioMailer.new(to_phone: params["From"]).send_invalid_user_notification
      head :ok
    end
  end

  private

  def notification_params
    params.require(:notification).permit(:user_id, :from, :to)
  end
end
