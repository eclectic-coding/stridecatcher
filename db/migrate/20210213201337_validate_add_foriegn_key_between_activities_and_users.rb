class ValidateAddForiegnKeyBetweenActivitiesAndUsers < ActiveRecord::Migration[6.1]
  def change
    validate_foreign_key :activities, :users
  end
end
