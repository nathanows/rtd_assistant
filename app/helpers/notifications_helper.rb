module NotificationsHelper

  def create_notification(message, user)
    from_loc, to_loc = message.downcase.split(" ")
    from = user.locations.where("name ILIKE ?", from_loc).first
    to = user.locations.where("name ILIKE ?", to_loc).first
    Notification.create(
      user_id: user.id,
      to: to.id,
      from: from.id,
      send_time: Time.now,
      source: "SMS"
    )
  end

  def valid_message?(message, user)
    from_loc, to_loc, *rest = message.split(" ")
    case
    when invalid_number?(user)
      return false, invalid_number_message
    when invalid_format?(rest)
      return false, invalid_format_message
    when invalid_from?(user, from_loc)
      return false, invalid_from_message(from_loc)
    when invalid_to?(user, to_loc)
      return false, invalid_to_message(to_loc)
    end
    return true, "No Message"
  end

  # VALIDATORS

  def invalid_number?(user)
    user.nil?
  end

  def invalid_format?(rest)
    rest.length != 0
  end

  def invalid_from?(user, from_loc)
    user_locs = user.locations.map(&:name).map(&:downcase)
    !user_locs.include?(from_loc.downcase)
  end

  def invalid_to?(user, to_loc)
    user_locs = user.locations.map(&:name).map(&:downcase)
    !user_locs.include?(to_loc.downcase)
  end

  # MESSAGES

  def invalid_number_message
    "<Response><Message>" +
    "Hmm... We're not finding this number in our system. Make sure that " +
    "this number is associated with your account at www.rtdassist.com." +
    "</Message></Response>"
  end

  def invalid_format_message
    "<Response><Message>" +
    "Whoopsie... that doesn't seem to be a valid message format." +
    "\n\nUse the format 'to_location_name from_location_name'" +
    "</Message></Response>"
  end

  def invalid_from_message(from_loc)
    "<Response><Message>" +
    "Sorry... #{from_loc} doesn't seem to be a valid location.\n\nMake sure " +
    "this location is created on your account at www.rtdassist.com." +
    "</Message></Response>"
  end

  def invalid_to_message(to_loc)
    "<Response><Message>" +
    "Sorry... #{to_loc} doesn't seem to be a valid location.\n\nMake sure " +
    "this location is created on your account at www.rtdassist.com." +
    "</Message></Response>"
  end
end
