class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :male_id
      t.integer :lady_doctor_id

      t.timestamps
      add_index :relationships, :male_id
      add_index :relationships, :lady_doctor_id
      add_index :relationships, [:male_id, :lady_doctor_id], unique: true
    end
  end
end
