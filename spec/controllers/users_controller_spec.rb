require 'spec_helper'

describe UsersController do
 render_views

  before(:each) do
   @base_title = 'Ruby on Rails Tutorial Sample App | '
  end

  describe "GET 'new'" do
    it "returns http success" do
      get :new
      response.should be_success
    end
    it 'should have the right title' do
      get :new
      response.should have_selector('title', :content=>'Sign Up')
    end
    it 'should have a name field' do
      get :new
      response.should have_selector("input[name='user[name]'][type='text']")
    end
    it 'should have a email field' do
      get :new
      response.should have_selector("input[name='user[email]'][type='text']")
    end
    it 'should have a password field' do
      get :new
      response.should have_selector("input[name='user[password]'][type='password']")
    end
    it 'should have a password confirmation field' do
      get :new
      response.should have_selector("input[name='user[password_confirmation]'][type='password']")
    end
  end
  describe "GET 'show'" do
    before(:each) do
      @user =  FactoryGirl.create(:user);
    end
    it 'should return http success' do
      get :show, :id=>@user
      response.should be_success
    end
    it 'should get the expected user' do
      get :show, :id=>@user
      assigns(:user).should == @user
    end
    it 'should have the right title' do
      get :show, :id=>@user
      response.should have_selector('title', :content=>@user.name)
    end
    it 'should have the user name in heading' do
      get :show, :id=>@user
      response.should have_selector('h1', :content=>@user.name)
    end
    it 'should have a profile image' do
      get :show, :id=>@user
      response.should have_selector('h1>img', :class=>'gravatar')
    end
  end
  describe "POST 'create'" do
    describe "failure" do
      before(:each) do
        @attr = {:name=>'',:email=>'',:password=>'',:password_confirmation=>''}
      end
      it "should not create a user" do
        lambda do
          post :create, :user=>@attr
        end.should_not change(User,:count)
      end
      it "should have the right title" do
        post :create, :user=>@attr
        response.should have_selector("title", :content=>"Sign Up")
      end
      it "should render the 'new' page" do
        post :create, :user=>@attr
        response.should render_template('new')
      end
    end
    describe "Success" do
      before(:each) do
        @attr = {:name=>'testName',:email=>'test@email.com',:password=>'123qwe',:password_confirmation=>'123qwe'}
      end
      it "should create a user" do
        lambda do
          post :create, :user=>@attr
        end.should change(User,:count).by(1)
      end
      it "should redirect to the user show page" do
        post :create, :user=>@attr
        response.should redirect_to(user_path(assigns(:user)))
      end
      it "should have a welcome message" do
        post :create, :user=>@attr
        flash[:success].should =~ /welcome to the sample app/i
      end
      it "should sign the user in" do
        post :create, :user=>@attr
        controller.should be_signed_in
      end
    end
  end
  describe "GET 'edit'" do
    before(:each) do
      @user = FactroyGirl.create(:user)
      test_sign_in(@user)
    end
    it "should be successful" do
      get :edit, :id=>@user
      response.should be_success
    end
    it "should have the right title" do
      get :edit, :id=>@user
      response.should have_selector(:title, :content=>"Edit user")
    end
    it "should have a link to change Gravatar" do
      get :edit, :id=>@user
      gravatar_url = "http://gravatar.com/emails"
      response.should have_selector("a", :href=>gravatar_url, :content=>'change')
    end
  end
end
