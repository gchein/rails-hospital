class Room < ApplicationRecord
  has_many :patients

  before_save :check_occupancy

  def current_occupancy
    patients.count
  end
end
