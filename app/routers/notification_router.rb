class NotificationRouter
  attr_reader :validator, :open_notification, :body, :user, :state

  def initialize(message_body, from)
    @body = message_body
    @user = User.joins(:phone_numbers).
      where(phone_numbers: { number: from }).first
    @open_notification = @user.open_notification
    @state = @open_notification.aasm_state if @open_notification
    @validator = SMSValidator.new(message_body, from, @user, @open_notification)
  end

  def call
    case
    when validator.valid_short_form? then process_short_form
    when validator.new_request?      then process_new_request
    when open_notification.nil?      then process_invalid_request
    when waiting_for_location?       then process_location
    when waiting_for_option?         then process_option
    else                                  process_invalid_request
    end
  end

  private

  def process_short_form
    user.close_open_requests
    from, to = saved_location_lookup
    Notification.create(user_id: user.id, from: from.id, to: to.id,
                        send_time: Time.now, pending: false)
  end

  def process_new_request
    user.close_open_requests
    Notification.create(user_id: user.id)
  end

  def process_invalid_request
    TwilioMailer.new(to_phone: from).send_invalid_notification
  end

  def process_location
    if validator.valid_location?
      open_notification.update_attributes(from: location_id_lookup) if waiting_for_from?
      open_notification.update_attributes(to: location_id_lookup) if waiting_for_to?
      open_notification.next_step!
    else
      TwilioMailer.new(to_phone: from).send_invalid_location_notification
    end
  end

  def process_option
    if validator.valid_option?
      SendNotification.new(open_notification, option_number).call
    else
      TwilioMailer.new(to_phone: from).send_invalid_option_notification
    end
  end

  def saved_location_lookup
    locations = body.downcase.split(" ")
    locations[0..1].map do |loc|
      user.locations.where("LOWER(name) LIKE ?", loc).first
    end
  end

  def option_number
    word1, word2 = body.downcase.split(" ")
    word1.to_i > 0 ? word1 : word2
  end

  def waiting_for_location?
    options = ["waiting_for_from", "waiting_for_to"]
    options.include? open_notification.aasm_state
  end

  def waiting_for_option?
    options = ["waiting_for_additional_option_requests"]
    options.include? open_notification.aasm_state
  end

  def waiting_for_from?
    state == "waiting_for_from"
  end

  def waiting_for_to?
    state == "waiting_for_to"
  end

  def location_id_lookup
    if presaved_location
      presaved_location.id
    else
      create_address.id
    end
  end

  def presaved_location
    word1, *rest = body.downcase.split(" ")
    if !rest.empty?
      false
    else
      user.locations.where("LOWER(name) LIKE ?", word1).first
    end
  end

  def create_address
    address     = Geocoder.search(body)
    base        = address.first.data["address_components"]
    street_num  = base[0]["short_name"]
    street_name = base[1]["short_name"]
    city        = base[3]["short_name"]
    state       = base[5]["short_name"]
    zipcode     = base[7]["short_name"]
    Location.create(
      lat: address.first.geometry["location"]["lat"],
      lng: address.first.geometry["location"]["lng"],
      street: "#{street_num} #{street_name}",
      city: city,
      state: state,
      zipcode: zipcode,
      active: true,
      saved_location: false,
      user_id: user.id
    )
  end
end
