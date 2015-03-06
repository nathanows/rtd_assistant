class PhoneNumber < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper

  belongs_to :user
  phony_normalize :number, :default_country_code => 'US'
  before_save :phone_number_activation

  def phone_number
    number_to_phone(number.last(10), area_code: true)
  end

  private

  def phone_number_activation
    self.active = true
  end
end
