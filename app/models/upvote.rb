class Upvote
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :music
  belongs_to :user


  def self.top_music_by_week
    musics = Upvote.collection.aggregate([
      {
        "$match": {
          "created_at": {"$gte": 7.days.ago}
        }
      },
      {
        "$group": {
          "_id": "$music_id",
          "total_upvotes": {"$sum": 1}
        }
      }
      ])

    musics = musics.map{ |e| [e[:_id], e[:total_upvotes]]}
    musics.map do |music|
      music[0] = Music.find(music[0])
    end
    
    musics
  end

end
