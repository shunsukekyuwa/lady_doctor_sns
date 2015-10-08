require 'rails_helper'

describe Male do
  #名前とメールとpasswordがあると有効な状態であること
  it "is valid with a name and an email and a password" do
    male = Male.new(
      name: '池田',
      email: 'hoge@gmail.com',
      password: 'hogeihoge')
    expect(male).to be_valid
  end
  #パスワードがなければ無効な状態であること
  it "is invalid without a password" do
    male = Male.new(password: nil)
    male.valid?
    expect(male.errors[:password]).to include("can't be blank")
  end
  #メールがなければ無効な状態であること
  it "is invalid without an email address" do
    male = Male.new(email: nil)
    male.valid?
    expect(male.errors[:email]).to include("can't be blank")
  end

  #名前がなければ無効な状態であること
  it "is invalid without a name" do
    male = Male.new(name:  nil)
    male.valid?
    expect(male.errors[:name]).to  include("can't be blank")
  end
  
  #重複したメールアドレスなら無効な状態であること
  it "is invalid with a duplicate email address" do
   Male.create(
     name: 'Joe', password: 'hogehoge',
     email: 'test@example.com'
   )
   male = Male.new(
     name: 'Jane', password: 'hogehoge',
     email: 'test@example.com'
   )
   male.valid?
   expect(male.errors[:email]).to include("has already been taken")
  end
end

