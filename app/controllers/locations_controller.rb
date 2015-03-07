class LocationsController < ApplicationController

  def create
    @location = Location.create(location_params)
    redirect_to dashboard_path
  end

  private

   def location_params
    params.require(:location).permit(:name, :street, :city, :state, :zipcode,
                                     :active, :saved_location, :user_id)
   end
end
