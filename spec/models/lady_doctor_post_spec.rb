require 'rails_helper'

describe LadyDoctorPost do
  #lady_doctor_idをもつlady_doctorが存在し、かつ、contentが存在すると有効な状態であること
  it "is valid with the male with a certain male_id and with a content" do
   ladydoctorpost = LadyDoctorPost.new(
      lady_doctor_id: 6,
      content: 'hoge')
    expect(ladydoctorpost).to be_valid
  end
  #lady_doctor_idをもつlady_doctorが存在しなければ無効な状態であること"
  it "is invalid without the male with a certain male_id" do
    lady_doctor_post = LadyDoctorPost.new(lady_doctor_id: nil)
    lady_doctor_post.valid?
    expect(lady_doctor_post.errors[:lady_doctor_id]).to include("can't be blank")
  end
  #contentがなければ無効な状態であること
  it "is invalid without a content" do
    ladydoctor_post = LadyDoctorPost.new(content: nil)
    ladydoctor_post.valid?
    expect(ladydoctor_post.errors[:content]).to include("can't be blank")
  end
end
