class CreateMalePostComments < ActiveRecord::Migration
  def change
    create_table :male_post_comments do |t|
      t.integer :lady_doctor_post_id
      t.integer :male_id
      t.string :comment

      t.timestamps
    end
  end
end
