class UsersController < ApplicationController
  load_and_authorize_resource :user

  def show
    if @user.musician?
      if current_user != @user
        if Chatroom.find_by(recipient_id: @user.id, sender_id: current_user.id) == nil
          @chatroom = Chatroom.new(recipient_id: @user.id, sender_id: current_user.id)
          @chatroom.save
        else
          @chatroom = Chatroom.find_by(recipient_id: @user.id, sender_id: current_user.id)
        end
      else
        @chatrooms = Chatroom.where(recipient_id: current_user.id)
        @chatrooms.to_a
      end
      @user.increment_visited
    end
  end

  def add_sm
    @user.update(sm_params)
    redirect_to @user
  end

  def change_background
    @user.update(bg_params)
    redirect_to @user
  end

  private

  def sm_params
    params.require(:user).permit(:fb, :yt, :ig, :tw)
  end

  def bg_params
    params.require(:user).permit(:background)
  end

end
