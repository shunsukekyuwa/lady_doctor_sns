class LadyDoctor < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  #done 'follow'
  has_many :follower_relationships, foreign_key: "lady_doctor_id", class_name: "Relationship", dependent: :destroy
  has_many :followers, through: :follower_relationships
  has_many :lady_doctor_posts

  #do 'like'
  #has_many :sending_likes, foreign_key: "male_id", class_name: "Like", dependent: :destroy
  has_many :likes

  has_many :lady_doctor_blocks

  def blocking?(male)
    lady_doctor_blocks.find_by(male_id: male.id) != nil
  end
  

  def sending?(male)
  	#p "--------------------------------"
  	#p self.id, male.id
  	#p likes.find_by(male_id: male.id) != nil
  	#p "--------------------------------"
    likes.find_by(male_id: male.id) != nil
  end

end
