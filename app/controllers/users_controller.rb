class UsersController < ApplicationController
  before_action :find_user, only:[:show, :edit, :update, :destroy]

  def show
    end

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params(:first_name, :last_name, :email, :password))
    if @user.valid?
      @user.save
      redirect_to user_path(@user)
    else
      flash[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def edit
  end

  def update
    @user.update(user_params(:first_name, :last_name, :email, :password))
    if @user.valid?
      @user.save
      redirect_to user_path(@user)
    else
      flash[:errors] = @user.errors.full_messages
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "The user and all location & meeting data was wiped out"
    redirect_to users_path

    flash[:success] = "The user and all location & meeting data was wiped out"
  end

  private
  def find_user
    @user = User.find(params[:id])
  end

  def user_params(*args)
    params.require(:user).permit(*args)
  end
end
