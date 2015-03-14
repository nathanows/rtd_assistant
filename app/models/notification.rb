class Notification < ActiveRecord::Base
  include AASM

  belongs_to :user
  has_one :direction_set
  has_many :routes, through: :direction_set

  aasm do
    state :request_received, :initial => true, :after_enter => :receive_request
    state :to_send_from_request
    state :waiting_for_from
    state :invalid_from_location
    state :to_send_to_request
    state :waiting_for_to
    state :invalid_to_location
    state :to_pull_directions, :after_enter => :pull_directions
    state :to_send_route_notification, :after_enter => :send_route_notification
    state :waiting_for_additional_option_requests
    state :to_send_additional_option_request
    state :completed

    event :route_request do
      transitions from: :request_received, to: :to_pull_directions,
        if: :completed_notification?
      transitions from: :request_received, to: :to_send_from_request
    end

    event :directions_pulled do
      transitions from: :to_pull_directions, to: :to_send_route_notification
    end

    event :notification_request_sent do
      transitions from: :to_send_route_notification,
        to: :waiting_for_additional_option_requests
    end

    event :next_step do
      transitions from: :to_send_from_request, to: :waiting_for_from
      transitions from: :waiting_for_from, to: :invalid_from_location,
        if: :invalid_from?
      transitions from: :invalid_from_location, to: :invalid_from_location,
        if: :invalid_from?
      transitions from: :waiting_for_from, to: :to_send_to_request
      transitions from: :invalid_from_location, to: :to_send_to_request
      transitions from: :to_send_to_request, to: :waiting_for_to
      transitions from: :waiting_for_to, to: :invalid_to_request,
        if: :invalid_to?
      transitions from: :invalid_to_location, to: :invalid_to_location,
        if: :invalid_to?
      transitions from: :waiting_for_to, to: :to_send_route_notification
      transitions from: :invalid_to_location, to: :to_send_route_notification
      transitions from: :waiting_for_additional_option_requests,
        to: :invalid_additional_option_request, if: :invalid_option_request?
      transitions from: :waiting_for_additional_option_requests,
        to: :to_send_additional_option_request
      transitions from: :to_send_additional_option_request,
        to: :waiting_for_additional_option_requests
      transitions from: :waiting_for_additional_option_requests, to: :completed
    end
  end


  private

    # CALLBACKS

    def receive_request
      route_request!
    end

    def pull_directions
      save
      GoogleMapsService.new(self).call
      directions_pulled!
    end

    def send_route_notification
      if SendNotification.new(self).call
        message_sent
      else
      end
    end

    # GUARDS

    def completed_notification?
      !pending?
    end

    def invalid_from?
    end

    def invalid_to?
    end

    # HELPERS

    def message_sent
      update_attributes(sent_time: Time.now, sent: true)
      save
      notification_request_sent!
    end
end
