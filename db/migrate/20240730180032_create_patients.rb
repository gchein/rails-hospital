class CreatePatients < ActiveRecord::Migration[7.1]
  def change
    create_table :patients do |t|
      t.string :name
      t.integer :age
      t.bigint :cpf
      t.string :gender
      t.boolean :under_care
      t.references :room, foreign_key: true

      t.timestamps
    end
  end
end
