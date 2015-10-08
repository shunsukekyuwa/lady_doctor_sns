require 'rails_helper'

describe Admin do
  #メールとpasswordがあると有効な状態であること
  it "is valid with an email and a password" do
    admin = Admin.new(
      email: 'hoge@gmail.com',
      password: 'hogehoge')
    expect(admin).to be_valid
  end

  #メールがなければ無効な状態であること
  it "is invalid without an email address" do
    admin = Admin.new(email: nil)
    admin.valid?
    expect(admin.errors[:email]).to include("can't be blank")
  end
  #passwordがなければ無効な状態であること
  it "is invalid without a password" do
    admin = Admin.new(password: nil)
    admin.valid?
    expect(admin.errors[:password]).to include("can't be blank")
  end
  #重複したメールアドレスなら無効な状態であること
  it "is invalid with a duplicate email address" do
    Admin.create(
      password: 'hogehoge',
      email: 'test@example.com'
   )
    admin = Admin.new(
      password: 'hogehoge',
      email: 'test@example.com'
   )
   admin.valid?
   expect(admin.errors[:email]).to include("has already been taken")
  end


end

