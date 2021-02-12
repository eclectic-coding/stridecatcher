require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(email: "uniquer@example.com", password: "123456", password_confirmation: "123456")
  end

  test "should be valid" do
    assert @user.valid?
  end

end
