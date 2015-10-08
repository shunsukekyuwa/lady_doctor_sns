require 'rails_helper'

describe LadyDoctor do
  #名前とメールと医師番号とpasswordがあると有効な状態であること
  it "is valid with a name and a password and an email and a doctor-number" do
    lady_doctor = LadyDoctor.new(
      name: 'ikeda',
      email: 'example@gmail.com',
      password: 'hogehoge',
      doctor_number: '111111')
    expect(lady_doctor).to be_valid
  end
  #名前がなければ無効な状態であること
  it "is invalid without a name" do
    lady_doctor = LadyDoctor.new(name: nil)
    lady_doctor.valid?
    expect(lady_doctor.errors[:name]).to include("can't be blank")
  end
  #メールがなければ無効な状態であること
  it "is invalid without an email address" do
    lady_doctor = LadyDoctor.new(email: nil)
    lady_doctor.valid?
    expect(lady_doctor.errors[:email]).to include("can't be blank")
  end
  #医師番号がなければ無効な状態であること
  it "is invalid without a doctor-number" do
    lady_doctor = LadyDoctor.new(doctor_number: nil)
    lady_doctor.valid?
    expect(lady_doctor.errors[:doctor_number]).to include("can't be blank")
  end
  #passwordがなければ無効な状態であること
  it "is invalid without a password" do
    lady_doctor = LadyDoctor.new(password: nil)
    lady_doctor.valid?
    expect(lady_doctor.errors[:password]).to include("can't be blank")
  end
  #重複したメールアドレスなら無効な状態であること
  it "is invalid with a duplicate email address" do
    LadyDoctor.create(
      name: 'Joe', password: 'hogehoge', doctor_number: '111111',
      email: 'test@example.com'
   )
    lady_doctor = LadyDoctor.new(
     name: 'Jane', password: 'hogehoge', doctor_number: '111112',
     email: 'test@example.com'
   )
   lady_doctor.valid?
   expect(lady_doctor.errors[:email]).to include("has already been taken")
  end

end

