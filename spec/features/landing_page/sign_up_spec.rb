require 'rails_helper'

describe "The Landing Page: Signup Process" do

  it "allows a user to sign up with Facebook" do
    valid_facebook_login_setup
    visit root_path
    find(:css, "#t_and_c").set(true)
    click_link_or_button "Sign up with Facebook"
    expect(page).to have_content("Dashboard")
  end

  it "allows a user to sign up with LinkedIn" do
    valid_linkedin_login_setup
    visit root_path
    find(:css, "#t_and_c").set(true)
    click_link_or_button "Sign up with LinkedIn"
    expect(page).to have_content("Dashboard")
  end

  it "allows a user to sign up with Google" do
    valid_google_login_setup
    visit root_path
    find(:css, "#t_and_c").set(true)
    click_link_or_button "Sign up with Google"
    expect(page).to have_content("Dashboard")
  end

  it "doesn't create a new user on second sign in" do
    expect(User.count).to eq 0
    valid_facebook_login_setup
    visit root_path
    find(:css, "#t_and_c").set(true)
    click_link_or_button "Sign up with Facebook"
    expect(User.count).to eq 1
    click_link_or_button "Logout"
    find(:css, "#t_and_c").set(true)
    click_link_or_button "Sign up with Facebook"
    expect(User.count).to eq 1
  end

  it "can sign in with omniauth for an existing user" do
    User.create!(
      email: "test@example.com",
      first_name: "Mickey",
      last_name: "Mouse",
      password: "password"
    )
    expect(User.count).to eq 1
    valid_facebook_login_setup
    visit root_path
    find(:css, "#t_and_c").set(true)
    click_link_or_button "Sign up with Facebook"
    expect(User.count).to eq 1
  end

  xit "redirects to root and flashes an error for an invalid login" do
    invalid_facebook_login_setup
    visit root_path
    find(:css, "#t_and_c").set(true)
    click_link_or_button "Sign up with Facebook"
    expect(current_path).to eq(root_path)
    expect(page).to have_content("Login error. Please try again.")
  end

end
