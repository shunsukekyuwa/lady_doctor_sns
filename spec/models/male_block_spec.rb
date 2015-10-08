require 'rails_helper'

describe MaleBlock do
  #male_idが存在してlady_doctor_idがdatabaseに存在していること
  it "is valid with existing unique male with a certain male_id and unique ladydoctor with a certain lady_doctor_id"
  #male_idにあてはまるmaleがdatabaseに存在してなければ無効な状態であること
  it "is invalid without male with a certain male_id"
  #lady_doctor_idにあてはまるlady_doctorがdatabaseに存在してなければ無効な状態であること
  it "is invalid without ladydoctor with a certain lady_doctor_id"
end
