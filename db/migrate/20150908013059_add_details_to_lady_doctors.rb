class AddDetailsToLadyDoctors < ActiveRecord::Migration
  def change
    add_column :lady_doctors, :sex, :string
    add_column :lady_doctors, :name, :string
    add_column :lady_doctors, :age, :integer
    add_column :lady_doctors, :birthplace, :string
    add_column :lady_doctors, :school, :string
    add_column :lady_doctors, :work, :string
    add_column :lady_doctors, :annual_income, :integer
    add_column :lady_doctors, :secret_state, :integer
    add_column :lady_doctors, :profile_image_id, :integer
    add_column :lady_doctors, :doctor_number, :integer
    add_column :lady_doctors, :confirm_state, :integer
  end
end
