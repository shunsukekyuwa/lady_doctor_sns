class AddImageToLadyDoctorPost < ActiveRecord::Migration
  def change
    add_column :lady_doctor_posts, :image, :string
  end
end
