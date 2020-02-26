class NotificationsController < ApplicationController
  def destroy
    @notification = Notification.where(id: params[:id])
    @notification.destroy

    redirect_back(fallback_location: home_path)
  end

  def destroy_all
    user = User.find(params[:user_id])
    user.notifications.destroy_all

    redirect_back(fallback_location: home_path)
  end

end
