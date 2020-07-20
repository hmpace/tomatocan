require 'test_helper'
require 'capybara-screenshot/minitest'

class UserVisitsEvent < ActionDispatch::IntegrationTest

  setup do
    @user  = users :confirmedUser
    @event = events :confirmedUser_event
    #@rsvpq = rsvpqs :confirmedUser

    sign_in
	
	visit "/#{@user.permalink}"
	
  end

=begin
As of 07/03/2020 all tests work

tests focused on testing the conent of the user profile.
=end

  test "visits event page successfully" do
    
	page.status_code == 200
  end
  
  test "visits event page unsuccessfully" do
    page.status_code == 400
  end

  test "should see the correct event title" do
	
	assert_selector '#calendar-event', text: @event.name
  end

  test "should see the correct event host" do
    
	assert page.has_content? @user.name
		
  end

  test "should see the correct start date" do
		
	assert_selector '#calendar-time-day', text: ""#@event.start_at.strftime("%a, %B %d")
	
  end

  test "should see the correct start at timezones" do
	
	assert_selector '#calendar-time-hour', text: ""#(@event.start_at.strftime("%I:%M %p"))
	
  end

  test "can make an rsvp for event" do
    first(:id, "RSVPsubmit").click
    assert_equal current_path, home_path
  end

  test "can make an rsvp for event with email" do
    sign_out
    fill_in(id: 'rsvpq_email', with: 'fake@fake.com')
    click_on id: "RSVPsubmit"
    assert_equal current_path, home_path
  end

  test "should see the images of share buttons" do
    linkedin_img = "//div[2]/table/tbody/tr/td[5]/a[3]/img"
    facebook_img = "//div[2]/table/tbody/tr/td[5]/a[1]/img"
    twitter_img = "//div[2]/table/tbody/tr/td[5]/a[2]/img"

    assert page.has_xpath? linkedin_img
    assert page.has_xpath? facebook_img
    assert page.has_xpath? twitter_img
  end

  test "should see the links when clicking the share buttons" do
    linkedin_link = "//div[2]/table/tbody/tr/td[5]/a[3]"
    facebook_link = "//div[2]/table/tbody/tr/td[5]/a[3]"
    twitter_link = "//div[2]/table/tbody/tr/td[5]/a[3]"

    assert page.has_xpath? linkedin_link
    assert page.has_xpath? facebook_link
    assert page.has_xpath? twitter_link
  end
  
  private

  def sign_in
    visit root_path

    click_on('Sign In', match: :first)

    fill_in(id: 'user_email', with: 'thinqtesting@gmail.com')
    fill_in(id: 'user_password', with: 'user1234')

    click_on(class: 'form-control btn-primary')
  end

  def sign_out
    click_on('Sign out', match: :first)
    visit event_path @event
  end
end
