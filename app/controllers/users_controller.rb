class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find_by(id: params[:id])
    render_404 unless @user
  end

    def create
      auth_hash = request.env["omniauth.auth"]

      user = User.find_by(uid: auth_hash[:uid],
                          provider: params[:provider])
      if user #user exists
        flash[:notice] = "Existing user #{user.username} is logged in."

      else #user does not exist
        user = User.build_from_github(auth_hash)
        if user.save
          flash[:success]= "Logged in as returning user #{user.username}"
        else
          flash[:error]= "Could not create user account: #{user.errors.messages}"
          return redirect_to root_path
        end
      end
      session[:user_id] = user.id
      redirect_to root_path
      # binding.pry
    end

  def logout
    session[:user_id] = nil
    flash[:status] = :success
    flash[:result_text] = "Successfully logged out"
    redirect_to root_path
  end
end
