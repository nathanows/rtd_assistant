module OmniauthHelper
  def valid_facebook_login_setup
    if Rails.env.test?
      OmniAuth.config.test_mode = true
      AuthenticationProvider.create(name: "facebook")
      OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
        provider: 'facebook',
        uid: '123545',
        info: {
          first_name: "Gaius",
          last_name:  "Baltar",
          email:      "test@example.com"
        },
        credentials: {
          token: "123456",
          expires_at: Time.now + 1.week
        },
        extra: {
          raw_info: {
            gender: 'male'
          }
        }
      })
    end
  end

  def valid_linkedin_login_setup
    if Rails.env.test?
      OmniAuth.config.test_mode = true
      AuthenticationProvider.create(name: "linkedin")
      OmniAuth.config.mock_auth[:linkedin] = OmniAuth::AuthHash.new({
        provider: 'linkedin',
        uid: '1235456',
        info: {
          first_name: "Hilarious",
          last_name:  "Baltar",
          email:      "test1@example.com"
        },
        credentials: {
          token: "1234567",
          expires_at: Time.now + 1.week
        },
        extra: {
          raw_info: {
            gender: 'female'
          }
        }
      })
    end
  end

  def valid_google_login_setup
    if Rails.env.test?
      OmniAuth.config.test_mode = true
      AuthenticationProvider.create(name: "google_oauth2")
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
        provider: 'google_oauth2',
        uid: '12354567',
        info: {
          first_name: "Funny",
          last_name:  "Baltar",
          email:      "test2@example.com"
        },
        credentials: {
          token: "12345678",
          expires_at: Time.now + 1.week
        },
        extra: {
          raw_info: {
            gender: 'female'
          }
        }
      })
    end
  end

  def invalid_facebook_login_setup
    if Rails.env.test?
      OmniAuth.config.test_mode = true
      AuthenticationProvider.create(name: "facebook")
      OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
        provider: 'facebook',
        info: {
          email:      "test8@example.com"
        },
        credentials: {
          invalid: :invalid_crendentials
        },
      })
    end
  end
end
