class AddForiegnKeyBetweenActivitiesAndUsers < ActiveRecord::Migration[6.1]
  def change
    add_foreign_key :activities, :users, validate: false
  end
end
