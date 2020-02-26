module MusicsHelper

def music_features_links(music)
  links = ["<span class='text-muted'> feat. </span>"]
  music.features.each do |user|
    links << link_to(user.name, user, class: "text-muted user-name-muted")
  end
  links.map{|link| content_tag :span, link}
  links.join.html_safe

end

end
