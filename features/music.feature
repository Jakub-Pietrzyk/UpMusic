Feature: Music
  In order to use the application
  I should be able to add, edit, read and destroy music

	Scenario: Adding music
    Given I am logged user
    And I visit main page
    When I click on add music button
    And Fill music form
    Then I should see that my music is added

  Scenario: Adding music with yt
    Given I am logged user
    And I visit main page
    When I click on add music button
    And Fill music form with yt link
    Then I should see that my music is added
    And I should be able to watch yt music video

  Scenario: Deleting music on music page
    Given I am logged user
    And I have a song added
    And I visit music page
    When I click on destroy button
    Then I should see that my music is deleted

  Scenario: Deleting music on user page
    Given I am logged user
    And I have a song added
    And I visit my profile
    When I click on destroy music button
    Then I should see that my music is deleted

  Scenario: Editing music
    Given I am logged user
    And I have a song added
    And I visit music page
    When I click on edit button
    And I edit something in the form
    Then I should see that my music is edited
    And I should be able to see the changes

  Scenario: Play music
    Given I am logged user
    And I have a song added
    And I visit music page
    When I click on play button
    Then I should be able to hear music

  Scenario: Stop music
    Given I am logged user
    And I have a song added
    And I visit music page
    And The music is playing
    When I click on stop button
    Then The music should stop

  Scenario: Upvote
    Given I am logged user
    And I have a song added
    And I visit music page
    When I click on upvote button
    Then The music should have one more upvote

  Scenario: Downvote
    Given I am logged user
    And I have a song added
    And I upvoted the music earlier
    And I visit music page
    When I click on downvote button
    Then The music should have one less upvote
