class CreateLadyDoctorPostComments < ActiveRecord::Migration
  def change
    create_table :lady_doctor_post_comments do |t|
      t.integer :lady_doctor_post_id
      t.integer :lady_doctor_id
      t.string :comment

      t.timestamps
    end
  end
end
