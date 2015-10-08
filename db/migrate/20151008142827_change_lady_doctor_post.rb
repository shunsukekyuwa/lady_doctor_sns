class ChangeLadyDoctorPost < ActiveRecord::Migration
  def change
    change_column :lady_doctor_posts, :lady_doctor_id, :integer, :null => false
    change_column :lady_doctor_posts, :content, :string, :null => false
  end
end
