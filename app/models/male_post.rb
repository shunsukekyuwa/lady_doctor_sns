class MalePost < ActiveRecord::Base
  belongs_to :male

  mount_uploader :image, ImageUploader

  validates :male_id, presence: true
  validates :content, presence: true
end
