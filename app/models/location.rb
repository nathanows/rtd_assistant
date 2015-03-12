class Location < ActiveRecord::Base
  belongs_to :user

  validates :name, format: { :with => /\A[a-zA-Z\d\-]*\z/ }, presence: true
  validates :street, :city, :state, :active, :user_id, :saved_location,
            presence: true

  geocoded_by :full_address, :latitude  => :lat, :longitude => :lng
  after_validation :geocode

  def lat_lng
    "#{lat},#{lng}"
  end

  private

  def full_address
    "#{street}, #{city}, #{state}, #{zipcode}"
  end
end
