class DashboardController < ApplicationController

  def index
    @user = current_user
    @phone_number = current_user.phone_numbers.new
    @location = current_user.locations.new
  end
end
