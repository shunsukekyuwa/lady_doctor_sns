class MalePostComment < ActiveRecord::Base
  belongs_to :male
  belongs_to :lady_doctor_post
end
