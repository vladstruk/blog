class SessionsController < ApplicationController

  def create
    user = User.by_login_data(params[:session])
    if user.try(:active?)
  	  session[:user_id] = user.id
  	  flash[:notice] = "You entered to the site!" 
      redirect_to articles_path
  	else
  	  flash[:error] = "Access denied!"
  	  redirect_to new_session_path
  	end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "You logged out"
    redirect_to new_session_path
  end
	
end
