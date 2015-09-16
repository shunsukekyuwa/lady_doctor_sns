class RemoveConfirmStateFromLadyDoctors < ActiveRecord::Migration
  def change
    remove_column :lady_doctors, :confirm_state, :integer
  end
end
