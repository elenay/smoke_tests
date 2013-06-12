require "selenium-webdriver"
require "rspec"
include RSpec::Expectations

describe "LogInAsUserAndMerch" do

  before(:each) do
    @driver = Selenium::WebDriver.for :firefox
    @base_url = "https://www.cplusi.com/"
    @accept_next_alert = true
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
  end
  
  after(:each) do
    @driver.quit
    @verification_errors.should == []
  end
  
  it "test_log_in_as_user_and_merch" do
    # open | /?login=false | 
    @driver.get(@base_url + "/?login=false")
    # click | id=sign-in-link | 
    @driver.find_element(:id, "sign-in-link").click
    # waitForElementPresent | id=sign-in-email | 
    !60.times{ break if (element_present?(:id, "sign-in-email") rescue false); sleep 1 }
    # type | id=sign-in-email | testdump+testdump+elena.yermakova@example.com 
    @driver.find_element(:id, "sign-in-email").clear
    @driver.find_element(:id, "sign-in-email").send_keys "testdump+testdump+elena.yermakova@example.com"
    # type | id=sign-in-password | 123456
    @driver.find_element(:id, "sign-in-password").clear
    @driver.find_element(:id, "sign-in-password").send_keys "123456"
    # click | id=sign-in-submit | 
    @driver.find_element(:id, "sign-in-submit").click
    # Warning: waitForTextPresent may require manual changes
    # waitForTextPresent | You have signed in successfully | 
    !60.times{ break if (@driver.find_element(:css, "BODY").text =~ /^[\s\S]*You have signed in successfully[\s\S]*$/ rescue false); sleep 1 }
    # click | //a[contains(@href, '/users/sign_out')] | 
    @driver.find_element(:xpath, "//a[contains(@href, '/users/sign_out')]").click
    # open | /?login=false | 
    @driver.get(@base_url + "/?login=false")
    # click | id=sign-in-link | 
    @driver.find_element(:id, "sign-in-link").click
    # waitForElementPresent | id=sign-in-email | 
    !60.times{ break if (element_present?(:id, "sign-in-email") rescue false); sleep 1 }
    # type | id=sign-in-email | elena.yermakova@chloeandisabel.com 
    @driver.find_element(:id, "sign-in-email").clear
    @driver.find_element(:id, "sign-in-email").send_keys "elena.yermakova@chloeandisabel.com"
    # type | id=sign-in-password | 123456
    @driver.find_element(:id, "sign-in-password").clear
    @driver.find_element(:id, "sign-in-password").send_keys "123456"
    # click | id=sign-in-submit | 
    @driver.find_element(:id, "sign-in-submit").click
    # Warning: waitForTextPresent may require manual changes
    # waitForTextPresent | You have signed in successfully | 
    !60.times{ break if (@driver.find_element(:css, "BODY").text =~ /^[\s\S]*You have signed in successfully[\s\S]*$/ rescue false); sleep 1 }
    # verifyElementPresent | merchandiser-toolbar | 
    # ERROR: Caught exception [Error: locator strategy either id or name must be specified explicitly.]
    # click | //a[contains(@href, '/users/sign_out')] | 
    @driver.find_element(:xpath, "//a[contains(@href, '/users/sign_out')]").click
  end
  
  def element_present?(how, what)
    @driver.find_element(how, what)
    true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end
  
  def verify(&blk)
    yield
  rescue ExpectationNotMetError => ex
    @verification_errors << ex
  end
  
  def close_alert_and_get_its_text(how, what)
    alert = @driver.switch_to().alert()
    if (@accept_next_alert) then
      alert.accept()
    else
      alert.dismiss()
    end
    alert.text
  ensure
    @accept_next_alert = true
  end
end