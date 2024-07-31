class Room < ApplicationRecord
  has_many :patients

  def current_occupancy
    patients.count
  end
end
