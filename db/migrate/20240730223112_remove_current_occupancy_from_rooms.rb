class RemoveCurrentOccupancyFromRooms < ActiveRecord::Migration[7.1]
  def change
    remove_column :rooms, :current_occupancy
  end
end
