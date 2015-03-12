class Notification < ActiveRecord::Base
  include AASM

  aasm do
    state :request_received, :initial => true
    state :to_send_from_request
    state :waiting_for_from
    state :invalid_from_location
    state :to_send_to_request
    state :waiting_for_to
    state :invalid_to_location
    state :to_send_route_notification
    state :waiting_for_additional_option_requests
    state :to_send_additional_option_request
    state :completed

    event :receive_request do
      transitions from: :request_received, to: :to_send_from_request
    end

    event :send_notification do
      transitions from: :request_received, to: :to_send_route_notification
    end

    event :send_from_request do
      transitions from: :to_send_from_request, to: :waiting_for_from
    end

    event :receive_from do
      transitions from: :waiting_for_from, to: :invalid_from_location,
        if: :invalid_from?
      transitions from: :invalid_from_location, to: :invalid_from_location,
        if: :invalid_from?
      transitions from: :waiting_for_from, to: :to_send_to_request
      transitions from: :invalid_from_location, to: :to_send_to_request
    end

    event :send_to_request do
      transitions from: :to_send_to_request, to: :waiting_for_to
    end

    event :receive_to do
      transitions from: :waiting_for_to, to: :invalid_to_request,
        if: :invalid_to?
      transitions from: :invalid_to_location, to: :invalid_to_location,
        if: :invalid_to?
      transitions from: :waiting_for_to, to: :to_send_route_notification
      transitions from: :invalid_to_location, to: :to_send_route_notification
    end

    event :send_route_notification do
      transitions from: :to_send_route_notification, to: :waiting_for_additional_option_requests
    end

    event :receive_additional_option_request do
      transitions from: :waiting_for_additional_option_requests,
        to: :to_send_additional_option_request
    end

    event :send_additional_option_request do
      transitions from: :to_send_additional_option_request, to: :waiting_for_additional_option_requests
    end

    event :close_notification do
      transitions from: :waiting_for_additional_option_requests, to: :completed
    end


    # GUARDS

    def invalid_from?
    end

    def invalid_to?
    end
  end


  include RoutesHelper

  belongs_to :user
  has_one :direction_set
  has_many :routes, through: :direction_set

  after_create :send_text_message

  def send_text_message
    response = JSON.parse(pull_directions)
    create_direction_set_routes(response, self)
    send_message(notification_message)
    mark_sent
  end

  private

  def send_message(message)
    number_to_send_to = user.phone_numbers.active.first.number

    twilio_sid = ENV["twilio_account_sid"]
    twilio_token = ENV["twilio_authtoken"]
    twilio_phone_number = ENV["twilio_phone_number"]

    @twilio_client = Twilio::REST::Client.new twilio_sid, twilio_token

    @twilio_client.messages.create(
      from: twilio_phone_number,
      to: number_to_send_to,
      body: message
    )
  end

  def notification_message
    from = Location.find(self.from)
    to = Location.find(self.to)
    route1 = routes.first
    route2 = routes.second
    route3 = routes.third
    route4 = routes.fourth
    "RTD ASSIST: #{from.name.capitalize} to #{to.name.capitalize}" +
    "\n\n1: #{route1.transit_type} ##{route1.transit_num} Departs: #{route1.transit_dep_time}" +
    "\n  - #{route1.walk_to_dep_time} #{route1.walk_to_dep_desc}" +
    "\n  - 0 Transfers" +
    "\n  - Arrives to #{route1.transit_arr_stop} at #{route1.transit_arr_time}" +
    "\n  - #{route1.walk_from_arr_time} walk to #{to.name.capitalize} (#{route1.arrival_time} Arrival)" +
    "\n\nOTHER OPTS (reply with 'option #' for more info)" +
    "\n\n2: #{route2.transit_type} ##{route2.transit_num} departs from #{route2.transit_dep_stop} at #{route2.transit_dep_time}" +
    "\n3: #{route3.transit_type} ##{route3.transit_num} departs from #{route3.transit_dep_stop} at #{route3.transit_dep_time}" +
    "\n4: #{route4.transit_type} ##{route4.transit_num} departs from #{route4.transit_dep_stop} at #{route4.transit_dep_time}"
  end

  def pull_directions
    from = Location.find(self.from)
    to = Location.find(self.to)
    maps_api = "https://maps.googleapis.com/maps/api/directions/json"
    RestClient.get maps_api,
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

  def mark_sent
    update_attributes(sent_time: Time.now, sent: true)
    save
  end
end
