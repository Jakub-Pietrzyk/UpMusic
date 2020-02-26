class Chatroom
  include Mongoid::Document

  belongs_to :recipient, class_name: "User", inverse_of: :recipient_chats
  belongs_to :sender, class_name: "User", inverse_of: :sender_chats
  has_many :messages
end
