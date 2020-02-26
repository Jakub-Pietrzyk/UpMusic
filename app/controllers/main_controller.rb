class MainController < ApplicationController
  include MainHelper

  def dashboard
    @week_musics = Music.top_by_week
    @visited_musics = Music.best_by_visited_ratio
  end

  def search
    if params[:search] == "*" and current_user.superadmin? != true
      params[:search] = nil
    end
    results_users = User.search params[:search], fields: [:name], where: {role: "musician"}, misspellings: {edit_distance: 0, below: 5}, match: :word_start
    results_music = Music.search params[:search], fields: [:title, :genre], misspellings: {edit_distance: 0, below: 5}, match: :word_start

    @music = music_sorted_by_upvotes(results_music.to_a)

    @users = results_users.to_a
  end

end
