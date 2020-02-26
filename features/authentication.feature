Feature: Authentication
  In order to use the application
  I should be able to log in and register

	Scenario: Creating musician account
    Given I visit the frontpage
    When I click on register button
    And click on register as musician button
    And I fill in signup form
    And I confirm the email
    Then I should see that my account was created

  Scenario: Creating observer account
    Given I visit the frontpage
    When I click on register button
    And click on register as observer button
    And I fill in signup form
    And I confirm the email
    Then I should see that my account was created


  Scenario: Creating account by google
    Given I visit the frontpage
    When I click on google button
    Then I should be logged in by google

  Scenario: Log in
    Given I am an registered user
    And I visit the frontpage
    When I click on login button
    And I fill in login form
    Then I should be logged in

  Scenario: Log in by google
    Given I visit the frontpage
    When I click on google button
    Then I should be logged in by google
