Given("I am logged user") do
  user = User.create(name: 'Jan', email: 'example@domain.com', password: "123456", confirmed_at: Time.now, role: 'musician')
  visit log_path
  click_on "log in"
  fill_in 'login-email', with: 'example@domain.com'
  fill_in 'login-password', with: '123456'
  click_on 'login-submit'
end

Given("I visit main page") do
  visit home_path
end

When("I click on add music button") do
  find("a[class='nav-link dropdown-toggle adding']").click
  click_link "Add music"
end

When("Fill music form") do
  fill_in "music-title-test", with: "Title"
  attach_file('music-file-test', 'features/support/przykład.mp3')
  find('#music-genre-test').find(:xpath, 'option[1]').select_option
  click_on "Create"
end

Then("I should see that my music is added") do
  expect(page).to have_content "Music added"
end

When("Fill music form with yt link") do
  fill_in "music-title-test", with: "Title"
  attach_file('music-file-test', 'features/support/przykład.mp3')
  find('#music-genre-test').find(:xpath, 'option[1]').select_option
  fill_in "music-yt-test", with: "example"
  click_on "submit"
end

Then("I should be able to watch yt music video") do
  @javascript
  expect(page).to have_content "Music added"
  page.should have_link("music-video")
end

Given("I visit music page") do
  user = User.find_by(email: "example@domain.com")
  song = Music.find_by(title: 'title')
  visit home_path
  find("a[name='profile']").click
  click_link "Profile"
  expect(page).to have_content user.name
  click_on song.title # music title
end

Given("I have a song added") do
  user = User.find_by(email: "example@domain.com")
  user.musics.create(title: 'title', file: open("features/support/przykład.mp3"), genre: "Rap")
end


When("I click on destroy button") do
  click_on "Delete"
end

Then("I should see that my music is deleted") do
  expect(page).to have_content "Music deleted"
end

Given("I visit my profile") do
  user = User.find_by(email: "example@domain.com")
  visit home_path
  find("a[name='profile']").click
  click_link "Profile"
  expect(page).to have_content user.name
end

When("I click on destroy music button") do
  user = User.find_by(email: "example@domain.com")
  music = user.musics.find_by(title: "title")
  click_on "delete_#{music.id}"
end

When("I click on edit button") do
  click_on "edit-music"
end

When("I edit something in the form") do
  fill_in "music-title-test", with: "new-title"
  find('#music-genre-test').find(:xpath, 'option[2]').select_option #opcje są od 1
  click_on "submit"
end

Then("I should see that my music is edited") do
  expect(page).to have_content "Music updated"
end

Then("I should be able to see the changes") do
  expect(page).to have_content "new-title"
  expect(page).to have_content Music.genres_to_choose[1] #tablica jest od 0
end

When("I click on play button") do
  pending
  # @javascript
  # find('#audio-player')
  # page.evaluate_script("$('#audio-player').play()")
end

Then("I should be able to hear music") do
  pending # Write code here that turns the phrase above into concrete actions
end

Given("The music is playing") do
  pending # Write code here that turns the phrase above into concrete actions
end

When("I click on stop button") do
  pending # Write code here that turns the phrase above into concrete actions
end

Then("The music should stop") do
  pending # Write code here that turns the phrase above into concrete actions
end

When("I click on upvote button") do
  click_on "upvote"
end

Then("The music should have one more upvote") do
  expect(page).to have_content "1 upvotes"
end

Given("I upvoted the music earlier") do
  song = Music.find_by(title: 'title')
  user = User.find_by(email: 'example@domain.com')
  song.upvotes.create(user_id: user.id)
end

When("I click on downvote button") do
  expect(page).to have_content "1 upvotes"
  click_on "downvote"
end

Then("The music should have one less upvote") do
  expect(page).to have_content "0 upvotes"
end
