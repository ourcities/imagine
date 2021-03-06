# coding: utf-8

Given(/^there is a problem$/) do
  @problem = Problem.make!
end

Given(/^there is an idea$/) do
  @idea = Idea.make!
end

Given(/^there is an idea for this problem$/) do
  @idea = Idea.make! :problem => @problem
end

Then(/^I should see that idea$/) do
  page.should have_css(".idea .title", :text => @idea.title[0..25])
end

When(/^I'm in "(.*?)"$/) do |arg1|
  visit path(arg1)
end

When(/^I click on "(.*?)"$/) do |arg1|
  click_link link(arg1)
end

Then(/^I should be logged in$/) do
  page.should have_css(".login", text: "Nícolas Iensen")
end

Then(/^I should be in "(.*?)"$/) do |arg1|
  page.current_path.should be_== path(arg1)
end

When(/^I click on the idea$/) do
  click_link @idea.title
end

Given(/^I'm logged in$/) do
  visit "/auth/facebook"
end

When(/^click to vote for this idea$/) do
  click_link "vote"
end

Then(/^I should see the message of thanks for voting$/) do
  page.should have_css(".thanks_for_voting")
end

Then(/^I should have one vote for this idea$/) do
  current_user.votes.where(:idea_id => @idea.id).count.should be_== 1
end

Given(/^I already voted for this idea$/) do
  @vote = Vote.make! idea: @idea, user: current_user
end

Then(/^I should see you already voted for this idea$/) do
  page.should have_css("a.vote.already_voted")
end

Given(/^there is a problem with a expired voting deadline$/) do
  @problem = Problem.make! voting_deadline: Time.now
end

Given(/^there is a problem with a expired contribution deadline$/) do
  @problem = Problem.make! ideas_deadline: Time.now
end

Then(/^the voting button should be disabled$/) do
  page.should have_css("a.vote[href='#']", text: "votações encerradas")
end

Given(/^there are some problems$/) do
  (rand*10).to_i.times { Problem.make! }
end

Then(/^I should see all the problems$/) do
  page.should have_css(".problem", count: Problem.count)
end

Given(/^I fill the contribution form$/) do
  within(".new_contribution") do
    fill_in "contribution_body", with: Faker::Lorem.paragraph
  end
end

When(/^I submit the contribution form$/) do
  within(".new_contribution") do
    click_link "submit_contribution"
  end
end

Then(/^I should be warned to wait for the idea's owner approval$/) do
  page.should have_css(".contribution_notice")
end

Then(/^I should have one contribution$/) do
  current_user.contributions.count.should_not be_zero
end

Then(/^I should see the error message for contribution field$/) do
  page.should have_css(".field_with_errors label.message[for='contribution_body']")
end

Given(/^there is an idea with an expired deadline for contribution$/) do
  @idea = Idea.make!
  @idea.problem.update_attributes ideas_deadline: Time.now
end

Then(/^I should not see the contribution form$/) do
  page.should_not have_css("form#new_contribution")
end

Then(/^an email should be send to the idea's owner$/) do
  ActionMailer::Base.deliveries.select{|m| m.to.index(@idea.user.email) > -1}.should_not be_empty
end

When(/^I click in the about page link$/) do
  click_link("about")
end

Given(/^I click on the new idea button$/) do
  click_link("new_idea")
end

Given(/^I fill the form for the new idea$/) do
  within "form.new_idea" do
    fill_in "idea_title", with: Faker::Lorem.sentence
    fill_in "idea_description", with: Faker::Lorem.paragraph
  end
end

When(/^I submit the new idea form$/) do
  within "form.new_idea" do
    find("input[type='submit']").click
  end
end

Then(/^I should be invited to share my new idea$/) do
  page.should have_css(".share_new_idea")
end

Then(/^I should see the error messages for idea$/) do
  page.should have_css(".field_with_errors label.message[for='idea_title']")
  page.should have_css(".field_with_errors label.message[for='idea_description']")
end

Then(/^I should see the preview of my new idea$/) do
  sleep(2)
  page.should have_css("#idea_preview .idea_description")
end

Then(/^I should not see the new idea link$/) do
  page.should_not have_css("a#new_idea")
end

When(/^I click on the contributions link$/) do
  click_link "contributions"
end

Then(/^I should see no pending contributions$/) do
  page.should have_css(".no_pending_contribution")
end

Given(/^I have some pending contributions$/) do
  idea = Idea.make! user: current_user
  @contribution = Contribution.make! idea: idea
end

Then(/^I should see these contributions$/) do
  page.should have_css(".contribution .body")
end

When(/^I accept the pending contribution$/) do
  within ".accept_or_reject" do
    find("a.accept").click
  end
end

Then(/^the contribution should be accepted$/) do
  @contribution.reload.should be_accepted
end

When(/^I reject the pending contribution$/) do
  within ".accept_or_reject" do
    find("a.reject").click
  end
end

Then(/^the contribution should be rejected$/) do
  @contribution.reload.should be_rejected
end

Given(/^I own an idea$/) do
  @idea = Idea.make!(:user => current_user)
end

When(/^I click on remove idea$/) do
  click_link "remove_idea"
end

Then(/^I should see a successful message$/) do
  page.should have_css(".notice")
end

Then(/^I should not see remove idea button$/) do
  page.should_not have_css("#remove_idea")
end

Given(/^I'm a logged kickass admin$/) do
  visit "/auth/facebook"
  current_user.admin = true
  current_user.save
end

Given(/^I click on edit idea$/) do
  click_link "edit_idea"
end

Given(/^I fill in idea's title with "(.*?)"$/) do |arg1|
  fill_in "idea_title", with: arg1
end

When(/^I submit the edit idea form$/) do
  within "form.edit_idea" do
    find("input[type='submit']").click
  end
end

Then(/^I should see "(.*?)" on the idea's title$/) do |arg1|
  page.should have_css(".idea_title h1", text: arg1)
end

Then(/^I should not see edit idea button$/) do
  page.should_not have_css("#edit_idea")
end

Then(/^an email should be sent to the contributor$/) do
  ActionMailer::Base.deliveries.should_not be_empty
end

Given(/^I click on the new problem button$/) do
  click_link "new_problem"
end

Given(/^I fill the problem form$/) do
  within(".new_problem") do
    fill_in "problem_title", with: Faker::Lorem.sentence
    fill_in "problem_description", with: Faker::Lorem.paragraph
    attach_file "problem_image", "#{Rails.root}/features/support/problem.jpeg"
    fill_in "problem_objectives", with: Faker::Lorem.paragraph
    fill_in "problem_hashtag", with: Faker::Lorem.words(1).sample
  end
end

When(/^I submit the problem form$/) do
  within "form.new_problem" do
    find("input[type='submit']").click
  end
end

Then(/^I should not see the new problem button$/) do
  page.should_not have_css("a#new_problem")
end

Given(/^I click on the edit problem button$/) do
  click_link "edit_problem"
end

Given(/^I change the problem's title to "(.*?)"$/) do |arg1|
  within(".edit_problem") do
    fill_in "problem_title", with: arg1
  end
end

When(/^I submit the edit problem form$/) do
  within "form.edit_problem" do
    find("input[type='submit']").click
  end
end

Then(/^the problem's title should be "(.*?)"$/) do |arg1|
  page.should have_css(".problem_title h1", text: arg1)
end

Then(/^I should not see the edit problem button$/) do
  page.should_not have_css("a#edit_problem")
end

When(/^I click on remove problem button$/) do
  click_link "remove_problem"
end

Then(/^I should not see the remove problem button$/) do
  page.should_not have_css("remove_problem")
end

When(/^I click on the updates button$/) do
  click_link "updates"
end

Then(/^I should see no updates yet$/) do
  page.should have_css(".no_updates_yet")
end

Given(/^there is an update$/) do
  @update = Update.make!
end

Then(/^I should see this update$/) do
  page.should have_css(".update .title", text: @update.reload.title)
end

When(/^I click on the update$/) do
  click_link("update_#{@update.id}_btn")
end

Then(/^I should see the update in a lightbox$/) do
  page.should have_css("#facebox .update_facebox")
end

Given(/^I click on add update button$/) do
  click_link "new_update"
end

Given(/^I fill the update form$/) do
  within "form.new_update" do
    fill_in "update_title", with: Faker::Lorem.sentence
    attach_file "update_image", "#{Rails.root}/features/support/problem.jpeg"
    fill_in "update_body", with: Faker::Lorem.paragraph
    fill_in "update_lead", with: Faker::Lorem.paragraph
  end
end

When(/^I submit the update form$/) do
  within "form.new_update" do
    find("input[type='submit']").click
  end
end

Then(/^I should see the new update$/) do
  page.should have_css(".update .title", text: last_update.title)
end

Then(/^I should not see add update button$/) do
  page.should_not have_css("a#new_update")
end

Then(/^I should see errors for the update fields$/) do
  page.should have_css(".field_with_errors label.message[for='update_title']")
  page.should have_css(".field_with_errors label.message[for='update_body']")
end

Then(/^I should see the new update on the Facebook page$/) do
  last_update.facebook_post_id.should_not be_nil
end

Given(/^there is an update for this problem$/) do
  @update = Update.make!(problem: @problem)
end

Then(/^I should see the update with a trash button$/) do
  page.should have_css(".update .icon-remove")
end

When(/^I click on the trash button$/) do
  within ".update" do
    find("a[class='icon-remove']").click
  end
end

Then(/^I should not see the update anymore$/) do
  page.should_not have_css(".update .title", text: @update.title)
end

Then(/^I should not see the update with a trash button$/) do
  page.should_not have_css(".update .icon-remove")
end

Then(/^I should see the edit update button$/) do
  page.should have_css(".update .icon-pencil")
end

When(/^I click on the edit update button$/) do
  within ".update" do
    find("a[class='icon-pencil']").click
  end
end

Then(/^I should see the edit update form$/) do
  page.should have_css("form.edit_update")
end

Given(/^I fill in title with "(.*?)"$/) do |arg1|
  within("form.edit_update") do
    fill_in "update_title", with: arg1
  end
end

When(/^I submit the edit update form$/) do
  within("form.edit_update") do
    find("input[type='submit']").click
  end
end

Then(/^I should not see the edit update button$/) do
  page.should_not have_css(".update .icon-pencil")
end
