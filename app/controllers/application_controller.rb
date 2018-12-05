class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?

  def current_user
   if session[:user_id]
     User.find(session[:user_id])
   else
     User.new
   end
  end

  def logged_in?
    current_user.id?
  end

  def authorized?
   if !logged_in?
     flash[:authorized] = "You aren't logged in!"
     redirect_to login_path
     false
   else
     true
   end
  end

  def authorized_for(user_id)
    if authorized? && current_user.id != user_id.to_i
      flash[:authorized] = "Ummm... You're not allowed to view this page, mate."
      redirect_to current_user
    end
  end
  
end
