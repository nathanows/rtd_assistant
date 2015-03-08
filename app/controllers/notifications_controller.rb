class NotificationsController < ApplicationController

  def create
    @notification = Notification.create(notification_params)
    redirect_to dashboard_path
  end

  def receive_text
    @user_name = User.joins(:phone_numbers)
      .where(phone_numbers: { number: '+15037087739' }).first.first_name

    render xml: "<Response><Message>Cool, we're on it #{@user_name}!</Message></Response>"
  end

  private

  def notification_params
    params.require(:notification).permit(:user_id, :from, :to, :sent_time)
  end
end
