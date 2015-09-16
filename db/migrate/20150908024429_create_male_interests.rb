class CreateMaleInterests < ActiveRecord::Migration
  def change
    create_table :male_interests do |t|
      t.integer :male_id
      t.integer :interest_id

      t.timestamps
    end
  end
end
