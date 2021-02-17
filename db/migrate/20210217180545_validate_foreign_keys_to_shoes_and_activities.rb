class ValidateForeignKeysToShoesAndActivities < ActiveRecord::Migration[6.1]
  def change
    validate_foreign_key :activities, :shoes
    validate_foreign_key :shoes, :users
  end
end
