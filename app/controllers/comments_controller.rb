class CommentsController < ApplicationController

  def create
    @music = Music.find(params[:music_id])
    @comment = @music.comments.create(comment_params)
    @comment.user_id = current_user.id

    user = User.find(@music.user_id)
    if current_user != user
      user.notifications.create(text: t(:commented), musician: current_user.id, music: @music.id)
    end

    if @comment.save
      flash[:notice] = t(:comment_added)
      redirect_to @music
    else
      flash[:notice] = t(:comment_adding_failed)
      redirect_to @music
    end

  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.destroy
      flash[:notice] = t(:comment_deleted)
      redirect_to @comment.music
    else
      flash[:notice] = t(:comment_deleting_failed)
      redirect_to @comment.music
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

end
