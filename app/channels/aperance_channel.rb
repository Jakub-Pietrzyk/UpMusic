class AperanceChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user
  end

  def unsubscribed
    current_user.is_offline
  end

  def appear
    current_user.is_online
  end

  def disappear
    current_user.is_offline
  end
end
