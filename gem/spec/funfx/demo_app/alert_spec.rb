require File.dirname(__FILE__) + '/../../spec_helper'

describe "DemoApp" do
  before(:all) do
    #FunFX.debug = true
    @browser = Browser.new
    @browser.visible = true if @browser.respond_to?(:visible=)
  end

  before(:each) do
    @browser.goto(DEMO_APP)
    @flex = @browser.flex_app('DemoApp')
  end
  
  after(:all) do
    FunFX.debug = false
    @browser.close
  end

  it "should be able to navigate an alert" do
    tree = @flex.tree({:id => 'objectTree'})
    tree.open!('General controls')
    sleep(1) 
    # sleep command: I Have a small screen on my computer, and when the tree is expanded a scrollbar appears
    # thus making the test  exit as it has done the select properly, but it has not and the following steps fail.
    # Hav tried to do some more sync work on the flex side, but it seems to be a bug
    tree.select!('General controls>Alert1')
    
    button = @flex.button({:automationName => 'Alert Control'}, {:id => 'bWorld'})
    button.click!
    
    alert = @flex.alert({:automationName => 'Message'})
    alert.visible?.should == true
    
    alert.text.strip.should == "Hello World!"
    
    button = @flex.button({:automationName => 'Message'},{:automationName => 'OK'})
    button.click!
    
    lambda do
      alert.visible?
    end.should raise_error("Error: Unable to resolve id '|automationName{Message string}'.")
  end
end