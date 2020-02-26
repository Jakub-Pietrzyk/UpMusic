class Music
  include Mongoid::Document
  include Mongoid::Paperclip
  include Mongoid::Timestamps

  searchkick word_start: [:title, :genre]

  field :title, type: String
  field :note, type: String
  field :genre, type: String
  field :visited, type: Integer, default: 0
  field :yt_video, type: String

  scope :by, ->(genre) {where(genre: genre)}

  has_mongoid_attached_file :file
  has_mongoid_attached_file :image,
    default_style: :thumb,
    styles:{
      thumb: ['100x100#', :png],
      play: ['300x300#', :png]
   },
   default_url: "/images/default_disc_:style.png"

  validates_attachment :image, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }
  validates_attachment :file, content_type: { content_type: ["audio/mpeg", "audio/mpeg3", "audio/x-mpeg-3", "video/mpeg", "video/x-mpeg"] }

  validates :title, presence: true
  validates :file, presence: true
  validates :genre, presence: true


  belongs_to :user, inverse_of: :musics
  has_many :upvotes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_and_belongs_to_many :features, class_name: "User", inverse_of: :featurings

  GENRES = %w[Rap Jazz Pop Country Rock Metal Latin Blues Reggae Electronic Folk R&B]
  YOUTUBE = "https://www.youtube.com/"

  def self.genres_to_choose
    GENRES
  end

  def self.random_by_genre(genre)
    musics = Music.by(genre)
    random = musics.skip(rand(musics.count)).first
  end


  def self.top_by_week(genre=nil)
    musics = Upvote.top_music_by_week

    if genre.present?
      sorted = []

      musics.each do |music|
        break if sorted.count > 10
        if music[0].genre == genre
          sorted.push(music)
        end
      end
      musics = sorted

    end
    musics.sort_by! {|music| music[1]}.reverse!
  end

  def self.hall_of_fame
    musics = Music.all.sort_by! { |music| music.upvotes.count}.reverse!
    musics[0...50]
  end

  def visited_ratio
    self.visited.to_i / (( Time.now - self.created_at) / 86400)
  end

  def self.best_by_visited_ratio(genre=nil)
    if genre.nil?
      musics = Music.all
    else
      musics = Music.by(genre)
    end
    musics = musics.sort_by! {|x| x.visited_ratio}.reverse!
    musics[0...10]
  end

  def increment_visited
    self.set(visited: (self.visited + 1))
  end

end
