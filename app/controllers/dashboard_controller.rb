class DashboardController < ApplicationController

  def index
    @user = current_user
    @phone_number = current_user.phone_numbers.new
    @location = current_user.locations.new
    @notification = current_user.notifications.new
  end
end
