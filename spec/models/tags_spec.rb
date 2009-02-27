require File.dirname(__FILE__) + '/../spec_helper'

describe "Adjusted breadcrumbs tag" do
  dataset :pages
  
  before :each do
    pages(:home).update_attributes(:class_name => "LanguageRedirectPage")
  end
  
  it "should not render the language-redirect page (homepage) in the breadcrumbs" do
    pages(:child_2).should render('<r:breadcrumbs nolinks="true" />').as('Parent &gt; Child 2')
  end
end