class CreateMalePosts < ActiveRecord::Migration
  def change
    create_table :male_posts do |t|
      t.integer :male_id
      t.string :content

      t.timestamps
    end
  end
end
