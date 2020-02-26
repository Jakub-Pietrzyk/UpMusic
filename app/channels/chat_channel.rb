class ChatChannel < ApplicationCable::Channel
  def subscribed
     stream_from "chat_channel"
  end

  def unsubscribed

  end

  def speak(data)
    chatroom = Chatroom.find(BSON::ObjectId.from_string(data['chatroom']))
    user = User.find(BSON::ObjectId.from_string(data['user']))
    Message.create!(content: data['message'], chatroom: chatroom, user: user)
  end
end
