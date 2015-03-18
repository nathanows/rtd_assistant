class GoogleMapsService
  include RoutesHelper

  attr_reader :notification, :maps_api, :from, :to

  def initialize(notification)
    @notification = notification
    @maps_api     = "https://maps.googleapis.com/maps/api/directions/json"
    @from         = Location.find(notification.from)
    @to           = Location.find(notification.to)
  end

  def call
    directions = JSON.parse(pull_directions)
    create_direction_set_routes(directions, notification)
  end

  private

    def pull_directions
      RestClient.get maps_api, maps_params
    end

    def maps_params
      { params:
        {
          origin: from.lat_lng,
          destination: to.lat_lng,
          mode: 'transit',
          alternatives: 'true',
          key: ENV['google_api_key']
        }
      }
    end
end
