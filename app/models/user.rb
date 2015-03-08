class User < ActiveRecord::Base
  has_many :authentications, class_name: 'UserAuthentication', dependent: :destroy
  has_many :phone_numbers
  has_many :locations
  has_many :notifications

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

  def phone_number
    phone_numbers.active?.first
  end
end
