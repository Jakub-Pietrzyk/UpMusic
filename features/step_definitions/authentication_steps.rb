Given("I visit the frontpage") do
  visit log_path
end

When("I click on register button") do
  click_on "Register"
end

When("click on register as musician button") do
  click_on "Sign up as musician"
end

When("I fill in signup form") do
  fill_in 'username', with: 'My name'
  fill_in 'email', with: 'example@domain.com'
  fill_in 'password', with: '123456'
  fill_in 'confirm password', with: '123456'
  click_on 'Create User'
end

When("I confirm the email") do
  # open_last_email #(current_email_address)
  # click_first_link_in_email
  open_email("example@domain.com")
  expect(current_email).to have_subject(/Confirmation instructions/)
  click_email_link_matching /confirm/
end

Then("I should see that my account was created") do
  expect(page).to have_content "Your email address has been successfully confirmed."
end

When("click on register as observer button") do
  click_on "Sign up as observer"
end

When("I click on google button") do
  @javascript #aby używał slenium i mógł wchodzić na zewnętrzne strony

  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:default] = OmniAuth::AuthHash.new({
     provider: "google",
     uid: "12345678910",
     info: {
       email: "example@gmail.com",
       image: "public/images/avatar_normal.png",
       email_verified: true,
       first_name: "Jakub",
       last_name: "Pietrzyk",
       name: "Jakub Pietrzyk"
     },
     credentials: {
       token: "abcdefg12345",
       refresh_token: "12345abcdefg",
       expires_at: "123123123",
       expires: true
     }
   })

  click_link "log-by-google"
end

When("I click on login button") do
  click_on "log in"
end

When("I fill in login form") do
  fill_in 'login-email', with: 'example@domain.com'
  fill_in 'login-password', with: '123456'
  click_on 'login-submit'
end

Then("I should be logged in") do
  expect(page).to have_content "Signed in successfully."
end

Then("I should be logged in by google") do
  expect(page).to have_content "Successfully authenticated from Google account."
end


Given("I am an registered user") do
  user = User.create(name: 'Jan', email: 'example@domain.com', password: "123456", confirmed_at: Time.now)
end
