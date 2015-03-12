class Notification < ActiveRecord::Base

  state_machine :state, initial: :pending do

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
