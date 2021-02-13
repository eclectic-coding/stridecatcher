class RemovePaceFromActivities < ActiveRecord::Migration[6.1]
  def change
    safety_assured { remove_column :activities, :pace, :integer }
  end
end
