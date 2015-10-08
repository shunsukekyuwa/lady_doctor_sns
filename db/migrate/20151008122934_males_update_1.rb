class MalesUpdate1 < ActiveRecord::Migration
  def change
    change_column :males, :name, :string, :null => false, default: ""
  end
end
