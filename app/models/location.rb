class Location < ActiveRecord::Base
  belongs_to :user

  skip_callback :validate, :after, :geocode, if: -> { self.lat && self.lng  }

  validates :name, format: { :with => /\A[a-zA-Z\d\-]*\z/ }
  validates :street, :city, :state, :user_id, presence: true

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
