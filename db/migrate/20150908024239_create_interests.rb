class CreateInterests < ActiveRecord::Migration
  def change
    create_table :interests do |t|
      t.string :title
      t.string :detail

      t.timestamps
    end
  end
end
