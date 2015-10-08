require 'rails_helper'

describe MalePostComment do
  #male_idをもつmaleが存在し、かつ、lady_doctor_post_idをもつlady_doctor_postが存在し、commentが存在すると有効な状態であること
  it "is valid with the male with a certain male_id and with the ladydoctor with a lady_doctor_id and a comment"
  #male_idをもつmaleが存在しなければ無効な状態であること
  it "is invalid without the male with each male_id"
  #lady_doctor_post_idをもつlady_doctor_postが存在しなければ無効な状態であること
  it "is invalid without the lady_doctor with each lady_doctor_id"
  #commentが存在しなければ無効な状態であること
  it "is invalid without a comment"

end
