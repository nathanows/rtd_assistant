class Location < ActiveRecord::Base
  belongs_to :user

  geocoded_by :full_address, :latitude  => :lat, :longitude => :lng
  after_validation :geocode

  private

  def full_address
    "#{street}, #{city}, #{state}, #{zipcode}"
  end
end
