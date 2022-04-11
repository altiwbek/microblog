class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :user_like]
  def index
    @posts = Post.all.order(created_at: :desc)
  end

  def show
    @post = Post.find(params[:id])
  end

  def create
    @post = current_user.posts.build(post_params)

    @post.save

    redirect_to root_url
  end

  def user_like
    @post = Post.find(params[:id])
    @like = PostUserLike.where(user: current_user, post: @post).first_or_create

    respond_to do |format|
      if @like.persisted?
        format.js
      else
        alert = "alert('Error: #{ @like.errors.full_messages.join("; ") }')"
        format.js { render js: (alert) }
      end
    end
  end

  def user_un_like
    @post = Post.find(params[:id])
    PostUserLike.where(user: current_user, post: @post).destroy_all
    respond_to { |format| format.js }
  end

  private

  def post_params
    params.require(:post).permit(:body)
  end
end
