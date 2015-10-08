class ChangeMalePost < ActiveRecord::Migration
  def change
    change_column :male_posts, :male_id, :integer, :null => false
    change_column :male_posts, :content, :string, :null => false
  end
end
