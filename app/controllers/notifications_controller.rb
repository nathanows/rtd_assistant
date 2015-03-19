class NotificationsController < ApplicationController

  def create
    user_phone = User.find_by(id: params[:user_id]).phone_number
    from = NotificationRouter.new(params[:from], user_phone).location_id_lookup
    to   = NotificationRouter.new(params[:to], user_phone).location_id_lookup
    @notification = Notification.create(
      user_id: params[:user_id],
      from: from,
      to: to
    )
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
