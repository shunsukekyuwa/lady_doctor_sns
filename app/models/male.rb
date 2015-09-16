class Male < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  #do 'follow'
  #has_many :following_relationships, foreign_key: "male_id", class_name: "Relationship", dependent: :destroy
  has_many :following_relationships, foreign_key: "lady_doctor_id", class_name: "Relationship", dependent: :destroy
  has_many :followings, through: :following_relationships

  
  
  has_many :male_posts
  has_many :male_post_comments

  def following?(lady_doctor)
    following_relationships.find_by(lady_doctor_id: lady_doctor.id)
  end

  def follow!(lady_doctor)
    following_relationships.create!(lady_doctor_id: lady_doctor.id)
  end

  def unfollow!(lady_doctor)
    following_relationships.find_by(lady_doctor_id: lady_doctor.id).destroy
  end
  

end
