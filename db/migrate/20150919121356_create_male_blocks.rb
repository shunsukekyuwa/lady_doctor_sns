class CreateMaleBlocks < ActiveRecord::Migration
  def change
    create_table :male_blocks do |t|
      t.integer :male_id
      t.integer :lady_doctor_id

      t.timestamps
    end
  end
end
