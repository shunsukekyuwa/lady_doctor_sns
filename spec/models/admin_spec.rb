require 'rails_helper'

describe Admin do
  #メールとpasswordがあると有効な状態であること
  it "is valid with an email and a password"
  #メールがなければ無効な状態であること
  it "is invalid without an email address"
  #passwordがなければ無効な状態であること
  it "is invalid without a password"
  #重複したメールアドレスなら無効な状態であること
  it "is invalid with a duplicate email address"
end

