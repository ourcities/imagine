Feature: contribute to an idea
  In order to improve an existing idea
  As a contributor
  I want to contribute to an idea

  @omniauth_test @javascript
  Scenario: when I'm logged in
    Given I'm logged in
    And there is an idea
    And I'm in "this idea page"
    And I fill the contribution form
    When I submit the contribution form
    Then I should be in "this idea page"
    And I should be warned to wait for the idea's owner approval
    And I should have one contribution
    And an email should be send to the idea's owner

  @omniauth_test @javascript
  Scenario: when I'm not logged in
    Given there is an idea
    And I'm in "this idea page"
    And I fill the contribution form
    When I submit the contribution form
    Then I should be in "this idea page"
    And I should be warned to wait for the idea's owner approval
    And I should have one contribution
    And an email should be send to the idea's owner

  @javascript
  Scenario: when I leave the contribution blank
    Given there is an idea
    And I'm in "this idea page"
    When I submit the contribution form
    Then I should be in "this idea page"
    And I should see the error message for contribution field

  Scenario: when the deadline to contribute expired
    Given there is an idea with an expired deadline for contribution
    When I'm in "this idea page"
    Then I should not see the contribution form
