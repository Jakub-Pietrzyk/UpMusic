class Message
  include Mongoid::Document
  include Mongoid::Timestamps
  after_create { MessageBroadcastJob.perform_later self.id.to_s }

  field :content, type: String

  belongs_to :chatroom
  belongs_to :user

  validates :content, presence: true
end
