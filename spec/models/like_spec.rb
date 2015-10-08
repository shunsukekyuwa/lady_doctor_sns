require 'rails_helper'

describe Like do
  #male_idをもつmaleとlady_doctor_idをもつlady_doctorをもつuserが存在すると有効な状態であること
  it "is valid with the male with each male_id and with the lady_doctor with each lady_doctor_id"
  #male_idをもつmaleがいなければ無効な状態であること
  it "is invalid without the male with each male_id"
  #lady_doctor_idをもつlady_doctorがいなければ無効な状態であること
  it "is invalid without the lady_doctor with each lady_doctor_id"
end

