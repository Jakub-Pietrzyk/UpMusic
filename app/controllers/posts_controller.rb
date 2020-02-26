class PostsController < ApplicationController
  load_and_authorize_resource :post

  def index
    @user = User.find(params[:user_id])
    @posts = Post.where(user_id: @user.id).all
  end

  def show

  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if current_user.superadmin?
      @post.super = true
    end

    if @post.save! and current_user.superadmin? == false
      flash[:notice] = t(:post_added)
      redirect_to @post
    elsif @post.save! and current_user.superadmin?
      flash[:notice] = t(:post_added)
      redirect_to super_posts_posts_path
    else
      flash[:alert] = t(:post_adding_failed)
      render 'new'
    end
  end

  def destroy

    user_id = @post.user_id
    @post.destroy

    flash[:notice] = t(:post_deleted)
    redirect_to user_path(user_id)
  end

  def edit

  end

  def update

    if @post.update(post_params)
      flash[:notice] = t(:post_updated)
      redirect_to @post
    else
      flash[:alert] = t(:post_updating_failed)
      render 'edit'
    end
  end

  def super_posts
    @posts = Post.super
    @posts = @posts.to_a
    @posts.sort_by! {|post| post.created_at}.reverse!
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :image)
  end

end
