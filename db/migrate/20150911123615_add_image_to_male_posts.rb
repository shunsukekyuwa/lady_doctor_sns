class AddImageToMalePosts < ActiveRecord::Migration
  def change
    add_column :male_posts, :image, :string
  end
end
