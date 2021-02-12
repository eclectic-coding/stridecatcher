require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  def setup
    @user = users(:confirmed_user)
  end
  test "should register" do
    visit new_user_registration_path

    assert_difference("user.count") do
      fill_in "Email", with: "unique@example.com"
      fill_in "Password", with: "password"
      fill_in "Password confirmation", with: "password"
    end

    click_button "Sign Up"
  end

  test "user can sign in" do
    visit new_user_session_path

    fill_in "Email", with: @user.email
    fill_in "Password", with: @user.password

    click_button "Log In"

    assert_selector "p", text: "Signed in successfully."
  end
end
