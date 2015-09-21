class ChangeLadyDoctorToLadyDoctorBlocks < ActiveRecord::Migration
  def change
  	rename_column :lady_doctor_blocks, :lady_doctor, :lady_doctor_id
  end
end
