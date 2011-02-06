Feature: Peer advisor can update admit availability

  So that I can specify the meeting availability for my admits
  As a peer advisor
  I want to update an admit's availability

  Background: I am signed in as a peer advisor and my admits are registered
    Given I am registered as a "Peer Advisor"
    And I am signed in
    And the following "Admits" have been added:
      | first_name  | last_name  | email            | phone      | area1   | area2   |
      | First1      | Last1      | email1@email.com | 1234567891 | Area 11 | Area 21 |
      | First2      | Last2      | email2@email.com | 1234567892 | Area 12 | Area 22 |
      | First3      | Last3      | email3@email.com | 1234567893 | Area 13 | Area 23 |
    And "Computer Science" has the following meeting times:
      | begin            | end              |
      | 1/1/2011 9:00AM  | 1/1/2011 11:00AM |
      | 1/1/2011 2:00PM  | 1/1/2011 02:45PM |
    And "Electrical Engineering" has the following meeting times:
      | begin            | end              |
      | 1/1/2011 12:00PM | 1/1/2011 03:00PM |

  Scenario: I update an admit's availability
    Given I am on the view admits page
    When I follow "Update Admit Availability" for the first admit
    When I flag the "1/1/2011 9:00AM" to "1/1/2011 9:15AM" slot as available
    And I flag the "1/1/2011 12:00PM" to "1/1/2011 12:15PM" slot as available
    And I press "Save changes"
    Then I should see "Admit was successfully updated"
