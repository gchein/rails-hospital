class Patient < ApplicationRecord
  AVAILABLE_GENDERS = %w[Male Female Non-Binary Undeclared]

  belongs_to :room, optional: true
  has_many :appointments
  has_many :doctors, through: :appointments

  validates :gender, inclusion: { in: AVAILABLE_GENDERS }
  validates :name, :age, :gender, presence: true

  validate :patient_able_to_enter_room?, :changed_to_valid_room?

  def allocate_to_room(new_room)
    self.room = new_room
    save
  end

  private

  def patient_able_to_enter_room?
    if room_changed? && room.present? && !room.space_left_in_room?
      errors.add(:base, "This room is full")
    end
  end

  def changed_to_valid_room?
    if under_care && room_changed? && !room.present?
      errors.add(:base, "Please select a valid room")
    end
  end
end
