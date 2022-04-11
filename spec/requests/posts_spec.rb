require "rails_helper"

RSpec.describe "Posts", type: :request do
  describe "GET /" do
    it "renders successfully" do
      get root_url

      expect(response).to be_successful
    end
  end

  describe "POST /posts" do
    let(:req) { post posts_url, params: { post: post_params } }

    context "with a user" do
      let(:user) { create(:user) }

      before { login_as user }

      context "with valid post parameters" do
        let(:post_params) { { body: "This is a post." } }

        it "creates a new post" do
          expect { req }.to change(Post, :count).by 1
        end

        it "associates the post with the logged in user" do
          req

          expect(Post.last.user).to eq user
        end

        it "redirects to the root url" do
          req
          expect(response).to redirect_to root_url
        end
      end

      context "without valid post parameters" do
        let(:post_params) { { body: "" } }

        it "does not create a new post" do
          expect { req }.not_to change(Post, :count)
        end

        it "redirects to the root url" do
          req
          expect(response).to redirect_to root_url
        end
      end
    end

    context "without a user" do
      let(:post_params) { { body: "This is a post." } }

      it "does not create a new post" do
        expect { req }.not_to change(Post, :count)
      end

      it "redirects to the new session url" do
        req
        expect(response).to redirect_to new_user_session_url
      end
    end
  end

  describe "GET /posts/:id" do
    let(:post) { create(:post) }
    let(:req) { get post_url(post) }

    it "renders successfully" do
      req

      expect(response).to be_successful
    end
  end

  describe "POST /user_like" do
    let(:post_) { create(:post) }
    let(:req) { post user_like_post_url(id: post_.id, format: :js) }
    let(:user) { create(:user) }

    before { login_as user }
    it "creates like successfully" do
      req

      expect(response).to be_successful
    end
  end

  describe "POST /user_un_like" do
    let(:post) { create(:post) }
    let(:user) { create(:user) }
    let(:post_user_like) { create(:post_user_like, user: user, post: post) }
    let(:req) { delete user_un_like_post_url(id: post.id, format: :js) }

    before { login_as user }
    it "destroys like successfully" do
      req

      expect(response).to be_successful
    end
  end
end
