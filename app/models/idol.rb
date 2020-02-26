class Idol
  include Mongoid::Document
  include Mongoid::Paperclip

  field :name, type: String
  field :page, type: String

  has_mongoid_attached_file :image,
    default_style: :thumb,
    styles:{
      thumb: ['50x50#', :png]
   },
   default_url: "/images/avatar_:style.png"

  validates_attachment :image, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }

  validates :name, presence: true

  belongs_to :user

  WIKIPEDIA = "https://www.wikipedia.org/"

  def link_to_idol_page
    WIKIPEDIA + self.page
  end

end
