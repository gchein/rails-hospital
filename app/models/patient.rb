class Patient < ApplicationRecord
  belongs_to :room, optional: true

  validates :gender, inclusion: { in: %w[Male Female Undeclared] }

  validate :check_room_availability

  def check_room_availability
    if room_changed? && room.present? && !room.space_left_in_room?
      errors.add(:base, "This room is full")
    end
  end
end
