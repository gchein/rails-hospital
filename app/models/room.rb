class Room < ApplicationRecord
  has_many :patients

  before_save :check_occupancy

  def check_occupancy
    puts "Current Occupancy: #{current_occupancy}"
    puts "Current number of Patients: #{patients.length}"
  end
end
