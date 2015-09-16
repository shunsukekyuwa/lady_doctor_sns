class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.integer :male_id
      t.integer :lady_doctor_id
      t.string :comment

      t.timestamps
    end
  end
end
