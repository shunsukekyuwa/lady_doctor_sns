class AddDetailsToMales < ActiveRecord::Migration
  def change
    add_column :males, :sex, :string
    add_column :males, :name, :string
    add_column :males, :age, :integer
    add_column :males, :birthplace, :string
    add_column :males, :school, :string
    add_column :males, :work, :string
    add_column :males, :annual_income, :integer
    add_column :males, :secret_state, :integer
    add_column :males, :profile_image_id, :integer
  end
end
