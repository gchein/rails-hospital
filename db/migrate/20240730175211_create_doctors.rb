class CreateDoctors < ActiveRecord::Migration[7.1]
  def change
    create_table :doctors do |t|
      t.string :name
      t.string :specialty
      t.string :position
      t.integer :years_in_field

      t.timestamps
    end
  end
end
