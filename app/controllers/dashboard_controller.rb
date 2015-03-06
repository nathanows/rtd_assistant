class DashboardController < ApplicationController

  def index
    @user = current_user
    @phone_number = current_user.phone_numbers.new
  end
end
