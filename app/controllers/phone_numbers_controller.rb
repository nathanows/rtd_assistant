class PhoneNumbersController < ApplicationController

  def create
    @phone_number = PhoneNumber.create(phone_number_params)
    redirect_to dashboard_path
  end

  private

   def phone_number_params
    params.require(:phone_number).permit(:user_id, :number, :name)
   end
end
