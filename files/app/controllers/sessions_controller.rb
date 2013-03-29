class SessionsController < ApplicationController

  def new
  end

  def create
    if user = User.authenticate(params[:session][:email],
                                params[:session][:password])
      sign_in user
      flash[:success] = t('flash.successful_signin')
      redirect_to root_url
      # redirect_back_or(user)
    else
      flash.now[:error] = t('flash.invalid_credentials')
      render 'new'
    end
  end

  def destroy
    sign_out
    flash[:success] = t('flash.successful_signout')
    redirect_to root_url
  end

  # private

  #   def redirect_back_or(default)
  #     redirect_to(session[:return_to] || default,
  #                 success: t('flash.successful_signin'))
  #     session.delete(:return_to)
  #   end

end