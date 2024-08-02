class Patient < ApplicationRecord
  AVAILABLE_GENDERS = %w[Male Female Non-Binary Undeclared]

  belongs_to :room, optional: true
  has_many :appointments
  has_many :doctors, through: :appointments

  validates :gender, inclusion: { in: AVAILABLE_GENDERS }
  validates :name, :age, :gender, presence: true

  validate :check_room_availability

  def check_room_availability
    if room_changed? && room.present? && !room.space_left_in_room?
      errors.add(:base, "This room is full")
    end
  end
end
