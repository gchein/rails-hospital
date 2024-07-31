class Room < ApplicationRecord
  has_many :patients

  def current_occupancy
    patients.count
  end

  def space_left_in_room?
    current_occupancy < capacity
  end
end
