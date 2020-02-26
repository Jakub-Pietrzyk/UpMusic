class UpvotesController < ApplicationController

  before_action :find_music
  before_action :find_upvote, only: [:destroy]

    def create
      if already_upvoted?
        flash[:notice] = t(:cannot_upvote_2)
      else
        if @music.upvotes.create(user_id: current_user.id)
          @music.user.add_recommendation(current_user, @music) if current_user.fame?
          redirect_to @music
        else
          flash[:notice] = t(:upvoting_failed)
          redirect_to @music
        end
      end
    end

    def destroy
      if !(already_upvoted?)
        flash[:notice] = t(:cannot_downvote)
      else
        if @upvote.destroy
          @music.user.destroy_recommendation(current_user) if current_user.fame?
          redirect_to @music
        else
          flash[:notice] = t(:downvoting_failed)
          redirect_to @music
        end
      end

    end

    private

    def find_music
      @music = Music.find(params[:music_id])
    end

    def already_upvoted?
      Upvote.where(user_id: current_user.id, music_id: params[:music_id]).exists?
    end

    def find_upvote
      @upvote = @music.upvotes.find(params[:id])
    end

end
