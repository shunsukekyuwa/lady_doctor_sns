class AddColumToMale < ActiveRecord::Migration
  def change
    add_column :males, :remember_token, :string
  end
end
