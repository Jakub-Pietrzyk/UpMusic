class MusicsController < ApplicationController

  def index
    @user = User.find(params[:user_id])
    @musics = Music.where(user_id: @user.id).all
  end

  def show
    @music = Music.find(params[:id])
    @music.increment_visited
  end

  def new
    @music = Music.new
  end

  def create
    @music = Music.new(music_params)
    @music.user_id = current_user.id

    if @music.save
      flash[:notice] = t(:music_added)
      redirect_to @music
    else
      flash[:alert] = t(:music_adding_failed)
      render 'new'
    end
  end

  def destroy
    @music = Music.find(params[:id])
    user_id = @music.user_id
    if @music.destroy
      flash[:notice] = t(:music_deleted)
      redirect_to user_path(user_id)
    else
      flash[:notice] = t(:music_deleting_failed)
      redirect_to user_path(user_id)
    end
  end

  def edit
    @music = Music.find(params[:id])
  end

  def update
    @music = Music.find(params[:id])

    if @music.update(music_params)
      flash[:notice] = t(:music_updated)
      redirect_to @music
    else
      flash[:alert] = t(:music_updating_failed)
      render 'edit'
    end
  end

  def show_by_genre
    @musics = Music.by(params[:genre])
    @visited_musics = Music.best_by_visited_ratio(params[:genre])
    @week_musics = Music.top_by_week(params[:genre])
  end


  def hall_of_fame
    @musics = Music.hall_of_fame
  end

  private

  def music_params
    params.require(:music).permit(:title, :note, :genre, :image, :file, :yt_video, :feature_ids => [])
  end

end
