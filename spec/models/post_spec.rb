require "rails_helper"

RSpec.describe Post, type: :model do
  it { is_expected.to validate_presence_of :body }

  it "returns true if liked_by user" do
    user = create(:user)
    post = create(:post, user: create(:user))
    create(:post_user_like, user: user, post: post)
    expect(post.liked_by?(user)).to be true
  end

  it "returns false if not liked_by user" do
    user = create(:user)
    post = create(:post, user: create(:user))
    expect(post.liked_by?(user)).to be false
  end
end
