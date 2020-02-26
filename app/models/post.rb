class Post
  include Mongoid::Document
  include Mongoid::Paperclip
  include Mongoid::Timestamps

  field :title, type: String
  field :body, type: String
  field :super, type: Boolean, default: false

  has_mongoid_attached_file :image,
    default_style: :original,
    styles:{
      original: ['500x500#', :png]
   }

   scope :super, ->{where(super: true)}

  validates_attachment :image, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }

  validates :title, presence: true
  validates :body, presence: true

  belongs_to :user

end
