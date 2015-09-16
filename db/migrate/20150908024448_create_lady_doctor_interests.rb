class CreateLadyDoctorInterests < ActiveRecord::Migration
  def change
    create_table :lady_doctor_interests do |t|
      t.integer :lady_doctor_id
      t.integer :interest_id

      t.timestamps
    end
  end
end
