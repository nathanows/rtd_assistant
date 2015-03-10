class NotificationsController < ApplicationController
  include NotificationsHelper

  def create
    @notification = Notification.create(notification_params)
    redirect_to dashboard_path
  end

  def receive_text
    message_body = params["Body"]
    user_number = params["From"]
    user = User.joins(:phone_numbers)
      .where(phone_numbers: { number: user_number }).first
    validity = valid_message?(message_body, user)
    if validity[0]
      create_notification(message_body, user)
      head :ok, content_type: "text/html"
    else
      render xml: validity[1]
    end
  end

  private

  def notification_params
    params.require(:notification).permit(:user_id, :from, :to, :sent_time)
  end
end
