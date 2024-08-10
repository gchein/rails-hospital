class Room < ApplicationRecord
  has_many :patients

  validates :capacity, presence: true
  validates :capacity, numericality: { only_integer: true, greater_than: 0 }

  def current_occupancy
    patients.count
  end

  def space_left_in_room?
    current_occupancy < capacity
  end
end
