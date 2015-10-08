class LadyDoctorPost < ActiveRecord::Base
	belongs_to :lady_doctor
	has_many :male_post_comments

  validates :lady_doctor_id, presence: true
  validates :content, presence: true

	mount_uploader :image, ImageUploader
end
