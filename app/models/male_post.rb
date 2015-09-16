class MalePost < ActiveRecord::Base
  belongs_to :male

  mount_uploader :image, ImageUploader
end
