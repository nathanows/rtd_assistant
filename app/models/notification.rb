class Notification < ActiveRecord::Base
  include AASM

  belongs_to :user
  has_one :direction_set
  has_many :routes, through: :direction_set

  aasm do
    state :request_received, :initial => true, :after_enter => :receive_request
    state :to_send_from_request, :after_enter => :send_notification
    state :waiting_for_from
    state :to_send_to_request, :after_enter => :send_notification
    state :waiting_for_to
    state :to_pull_directions, :after_enter => :pull_directions
    state :to_send_route_notification, :after_enter => :send_notification
    state :waiting_for_additional_option_requests
    state :completed

    event :next_step do
      transitions from: :request_received, to: :to_pull_directions,
        if: :completed_notification?
      transitions from: :request_received, to: :to_send_from_request
      transitions from: :to_send_from_request, to: :waiting_for_from
      transitions from: :waiting_for_from, to: :to_send_to_request
      transitions from: :to_send_to_request, to: :waiting_for_to
      transitions from: :waiting_for_to, to: :to_pull_directions
      transitions from: :to_pull_directions, to: :to_send_route_notification
      transitions from: :to_send_route_notification,
        to: :waiting_for_additional_option_requests
    end

    event :close_notification do
      transitions from: :waiting_for_additional_option_requests, to: :completed
    end
  end

  private

    # CALLBACKS

    def receive_request
      next_step!
    end

    def pull_directions
      GoogleMapsService.new(self).call
      next_step!
    end

    def send_notification
      SendNotification.new(self).call
      next_step!
    end

    # GUARDS

    def completed_notification?
      !from.nil? && !to.nil?
    end

    # HELPERS

    def route_notification_sent
      update_attributes(sent_time: Time.now, sent: true)
      save
      notification_request_sent!
    end
end
