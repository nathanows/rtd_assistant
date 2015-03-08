class Notification < ActiveRecord::Base
  belongs_to :user
  after_create :send_text_message

  def send_text_message
    number_to_send_to = user.phone_numbers.active.first.number
    from_name = Location.find(from).name
    to_name = Location.find(to).name
    message = "Notification request received good buddy! Going from #{from_name} to #{to_name}"

    twilio_sid = ENV["twilio_account_sid"]
    twilio_token = ENV["twilio_authtoken"]
    twilio_phone_number = ENV["twilio_phone_number"]

    @twilio_client = Twilio::REST::Client.new twilio_sid, twilio_token

    @twilio_client.messages.create(
      from: twilio_phone_number,
      to: number_to_send_to,
      body: message
    )

    update_attributes(sent_time: Time.now, sent: true)
    save
  end
end
