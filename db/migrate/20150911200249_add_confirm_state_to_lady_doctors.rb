class AddConfirmStateToLadyDoctors < ActiveRecord::Migration
  def change
    add_column :lady_doctors, :confirm_state, :boolean, default: false, null: false
  end
end
