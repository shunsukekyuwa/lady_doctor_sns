class LadyDoctorPost < ActiveRecord::Base
	belongs_to :lady_doctor
	has_many :male_post_comments

	mount_uploader :image, ImageUploader
end
