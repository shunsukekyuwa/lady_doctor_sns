class CreateLadyDoctorBlocks < ActiveRecord::Migration
  def change
    create_table :lady_doctor_blocks do |t|
      t.integer :male_id
      t.integer :lady_doctor

      t.timestamps
    end
  end
end
