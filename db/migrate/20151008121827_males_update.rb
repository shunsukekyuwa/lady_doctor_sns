class MalesUpdate < ActiveRecord::Migration
  def change
    change_column :males, :name, :string, :null => false
  end
end
