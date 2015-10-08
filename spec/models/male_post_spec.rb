require 'rails_helper'

describe MalePost do
  #male_idをもつmaleが存在し、かつ、contentが存在すると有効な状態であること
  it "is valid with the male with a certain male_id and with a content" do
    malepost = MalePost.new(
      male_id: 6,
      content: 'hoge')
    expect(malepost).to be_valid
  end
  #male_idをもつmaleが存在しなければ無効な状態であること
  it "is invalid without the male with a certain male_id" do
    male_post = MalePost.new(male_id: nil)
    male_post.valid?
    expect(male_post.errors[:male_id]).to include("can't be blank")
  end
  #contentがなければ無効な状態であること
  it "is invalid without a content" do
    male_post = MalePost.new(content: nil)
    male_post.valid?
    expect(male_post.errors[:content]).to include("can't be blank")
  end
end
