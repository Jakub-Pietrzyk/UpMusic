class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    message = Message.find(BSON::ObjectId.from_string(message))
    ActionCable.server.broadcast 'chat_channel', message: render_message(message)
  end

  private

  def render_message(message)
    ApplicationController.renderer.render(partial: 'messages/message', locals: { message: message})
  end
end
