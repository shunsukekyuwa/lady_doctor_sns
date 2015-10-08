class ChangeLadyDoctor < ActiveRecord::Migration
  def change
    change_column :lady_doctors, :name, :string, :null => false
    change_column :lady_doctors, :doctor_number, :integer, :null => false

  end
end
