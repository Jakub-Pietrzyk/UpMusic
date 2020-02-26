class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :body, type: String

  validates :body, presence: true

  belongs_to :music
  belongs_to :user

end
