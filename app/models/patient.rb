class Patient < ApplicationRecord
  belongs_to :room, optional: true

  validates :gender, inclusion: { in: %w[Male Female Undeclared] }

  before_save :check_room_availability

  def check_room_availability
    if new_valid_room? || room.current_occupancy < room.capacity
      errors.add(:base, "Friendship between these users already exists")
    end
  end

  def new_valid_room?
    room_changed? && !room.nil?
  end

end
