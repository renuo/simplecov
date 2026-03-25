@rspec @disable-bundler @process_fork

Feature:

  rspec-conductor and its corresponding test project work together with SimpleCov
  just fine and they produce the same output like a normal rspec run.

  Background:
    Given I'm working on the project "rspec_conductor"

  Scenario: Running it through rspec-conductor produces the same results as a normal rspec run
    Given I install dependencies
    And SimpleCov for RSpec is configured with:
      """
      require 'simplecov'
      SimpleCov.start
      """
    When I open the coverage report generated with `bundle exec rspec-conductor -w 2 --first-is-1 --no-prefork-require -- spec`
    Then I should see the line coverage results for the rspec-conductor project

  # Note it's better not to test this in the same scenario as before.
  # Merging of results might kick in and ruin this.
  Scenario: Running the project with normal rspec
    Given I install dependencies
    And SimpleCov for RSpec is configured with:
      """
      require 'simplecov'
      SimpleCov.start
      """
    When I open the coverage report generated with `bundle exec rspec spec`
    Then I should see the line coverage results for the rspec-conductor project

  @branch_coverage
  Scenario: Running the project with rspec-conductor and branch coverage
    Given I install dependencies
    And SimpleCov for RSpec is configured with:
      """
      require 'simplecov'
      SimpleCov.start do
        enable_coverage :branch
      end
      """
    When I open the coverage report generated with `bundle exec rspec-conductor -w 2 --first-is-1 --no-prefork-require -- spec`
    Then I should see the branch coverage results for the rspec-conductor project

  Scenario: No warning about parallel_tests is printed
    Given I install dependencies
    And SimpleCov for RSpec is configured with:
      """
      require 'simplecov'
      SimpleCov.start
      """
    When I successfully run `bundle exec rspec-conductor -w 2 --first-is-1 --no-prefork-require -- spec`
    Then the output should not match /guessed you were running inside parallel tests/
