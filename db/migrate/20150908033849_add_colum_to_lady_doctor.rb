class AddColumToLadyDoctor < ActiveRecord::Migration
  def change
    add_column :lady_doctors, :remember_token, :string
  end
end
