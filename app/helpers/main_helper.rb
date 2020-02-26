module MainHelper

  def music_sorted_by_upvotes(music)
    music.sort_by! { |obj|
      obj.upvotes.count
    }
    music.reverse!
  end

end
