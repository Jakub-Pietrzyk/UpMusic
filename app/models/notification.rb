class Notification
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :text, type: String
  field :music, type: BSON::ObjectId, default: nil
  field :fame, type: BSON::ObjectId, default: nil
  field :musician, type: BSON::ObjectId, default: nil

  belongs_to :user

end
