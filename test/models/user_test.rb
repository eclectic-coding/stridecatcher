require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(email: "uniquer@example.com", password: "123456", password_confirmation: "123456")
    @user_with_activities = users(:confirmed_user_with_activities)
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "should have default value of UTC in time_zone" do
    @user.save
    assert_equal "UTC", @user.reload.time_zone
  end

  test "should delete associated activities" do
    assert_difference("Activity.count", -"#{@user_with_activities.activities.count}".to_i) do
      @user_with_activities.destroy
    end
  end

end
