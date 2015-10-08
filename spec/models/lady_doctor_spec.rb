require 'rails_helper'

describe LadyDoctor do
  #名前とメールと医師番号とpasswordがあると有効な状態であること
  it "is valid with a name and a password and an email and a doctor-number"
  #名前がなければ無効な状態であること
  it "is invalid without a name"
  #メールがなければ無効な状態であること
  it "is invalid without an email address"
  #医師番号がなければ無効な状態であること
  it "is invalid without a doctor-number"
  #passwordがなければ無効な状態であること
  it "is invalid without a password"
  #重複したメールアドレスなら無効な状態であること
  it "is invalid with a duplicate email address"
end

