require 'spec_helper'

describe PagesController do
 render_views

  before(:each) do
   @base_title = 'Ruby on Rails Tutorial Sample App | '
  end

  describe "GET 'home'" do
    it "returns http success" do
      get 'home'
      response.should be_success
    end
  end

  describe "GET 'contact'" do
    it "returns http success" do
      get 'contact'
      response.should be_success
    end
  end

  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_success
    end
  end

  describe "GET 'title' for test" do
    it "should have the right title" do
      get 'home'
      response.should have_selector('title',:content=>@base_title+"dynamic home variable")
    end
  end
end