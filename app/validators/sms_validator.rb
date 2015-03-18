class SMSValidator
  attr_reader :body, :from, :user

  def initialize(message_body, from, user=nil, notification=nil)
    @body = message_body
    @from = from
    @user = user
  end

  def user?
    User.joins(:phone_numbers).where(phone_numbers: { number: from }).first
  end

  def valid_short_form?
    user_locations = user.active_saved_location_names.map{|loc|loc.downcase}
    word1, word2 = body.downcase.split(" ")
    user_locations.include?(word1) && user_locations.include?(word2)
  end

  def valid_location?
    presaved_location? || valid_address?
  end

  def valid_option?
    (option_start? || only_number?) && valid_option_number?
  end

  def new_request?
    word1, word2 = body.downcase.split(" ")
    (word1 == "new" || word1 == "notification") &&
      (word2 == "notification" || word2 == "request") ||
      (word1 == "new" && word2.to_s.empty?)
  end

  private

  def presaved_location?
    word1 = body.downcase.split(" ")
    user.locations.find_by(name: word1)
  end

  def valid_address?
    Geocoder.search(body)
  end

  def option_start?
    word1, word2 = body.downcase.split(" ")
    word1 == 'option' && (1..4).cover?(word2.to_i)
  end

  def only_number?
    word1, *rest = body.downcase.split(" ")
    (1..4).cover?(word1.to_i) && rest.empty?
  end

  def valid_option_number?
    true
  end
end
