class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user and @user.authenticate(params[:session][:password])
      if @user.activated?
        # login success
        log_in @user
        if params[:session][:remember_me] == '1'
          remember @user
        else
          forget(@user)
        end
        redirect_back_or @user
      else
        # not yet activated
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      # login fail
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
