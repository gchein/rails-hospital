class AddDefaultTrueToPatientUnderCare < ActiveRecord::Migration[7.1]
  def change
    change_column_default :patients, :under_care, true
  end
end
