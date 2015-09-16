class CreateLadyDoctorPosts < ActiveRecord::Migration
  def change
    create_table :lady_doctor_posts do |t|
      t.integer :lady_doctor_id
      t.string :content

      t.timestamps
    end
  end
end
