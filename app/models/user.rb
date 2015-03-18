class User < ActiveRecord::Base
  has_many :authentications, class_name: 'UserAuthentication', dependent: :destroy
  has_many :phone_numbers
  has_many :locations
  has_many :notifications

  validates :email, :first_name, :last_name, presence: true

  devise :omniauthable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def self.create_from_omniauth(params)
    attributes = {
      email: params['info']['email'],
      password: Devise.friendly_token,
      first_name: params['info']['first_name'],
      last_name: params['info']['last_name'],
      image: params['info']['image']
    }

    create(attributes)
  end

  def active_saved_location_names
    locations.where(active: true).where(saved_location: true).map(&:name)
  end

  def phone_number
    phone_numbers.active.first.number
  end

  def open_notification
    notifications.where.not(aasm_state: "completed").first
  end

  def close_open_requests
    notifications.where.not(aasm_state: "completed").map do |notification|
      notification.close_notification!
    end
  end
end
