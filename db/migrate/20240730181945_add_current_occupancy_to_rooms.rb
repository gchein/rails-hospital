class AddCurrentOccupancyToRooms < ActiveRecord::Migration[7.1]
  def change
    add_column :rooms, :current_occupancy, :integer, default: 0
  end
end
