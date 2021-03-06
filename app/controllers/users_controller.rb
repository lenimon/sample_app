class UsersController < ApplicationController
  def new
    @title="Sign Up"
    @user = User.new
  end
  def show
    @user = User.find(params[:id])
    @title = @user.name
  end
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      redirect_to @user
      flash[:success] = "Welcome to the Sample App!"
    else
      @title = "Sign Up"
      render 'new'
    end
  end
  def edit
    @user = User.find(params[:id])
    @title = "Edit user"
  end
end
