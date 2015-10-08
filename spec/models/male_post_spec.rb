require 'rails_helper'

describe MalePost do
  #male_idをもつmaleが存在し、かつ、contentが存在すると有効な状態であること
  it "is valid with the male with a certain male_id and with a content"
  #male_idをもつmaleが存在しなければ無効な状態であること
  it "is invalid without the male with a certain male_id"
  #contentがなければ無効な状態であること
  it "is invalid without a content"
end
