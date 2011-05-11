require File.dirname(__FILE__) + "/../spec_helper"

describe "LanguageRedirectPage" do

  before :each do
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
    @page = LanguageRedirectPage.new
    @page.stub!(:url).and_return('/')
    @page.parts.build(:name => 'config', :content => {'de' => '/de/', 'es' => '/es/', '*' => '/en/'}.to_yaml)
    @request.request_uri = '/'
  end

  it "should select the * entry when no language is given" do
    @page.process(@request, @response)
    @response.should be_redirect
    @response.redirect_url.should == "http://test.host/en/"
  end

  it "should select the * entry when no language matches" do
    @request.env['HTTP_ACCEPT_LANGUAGE'] = "jp, fr"
    @page.process(@request, @response)
    @response.should be_redirect
    @response.redirect_url.should == "http://test.host/en/"
  end

  it "should select the first matching language in order given (when all weights are same)" do
    @request.env['HTTP_ACCEPT_LANGUAGE'] = "es, de, en"
    @page.process(@request, @response)
    @response.should be_redirect
    @response.redirect_url.should == "http://test.host/es/"
  end

  it "should select the first matching language with the highest weight" do
    @request.env['HTTP_ACCEPT_LANGUAGE'] = "de;q=0.7, es;q=0.9, en;q=0.2"
    @page.process(@request, @response)
    @response.should be_redirect
    @response.redirect_url.should == "http://test.host/es/"
  end

  it "should append the request URI to the redirect location, cleaning up extra slashes" do
    @request.request_uri = '/freight/'
    @page.process(@request, @response)
    @response.redirect_url.should == "http://test.host/en/freight/"
  end

  describe "when a child page is not found" do
    dataset :language_redirect

    before :each do
      @page = pages(:home)
      @page.slug = "freight"
      @page.save!
      @page.parts.create!(:name => 'config', :content => {'de' => '/parent/', 'es' => '/es/', '*' => '/en/'}.to_yaml)
    end

    it "should return self if the URL doesn't match any of the redirect locations" do
      Page.find_by_url('/freight/').should == @page
    end

    it "should return the found page or nil if the URL matches a redirect location" do
      Page.find_by_url('/en/freight/').should_not == @page
    end
  end
end