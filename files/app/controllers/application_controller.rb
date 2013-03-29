class ApplicationController < ActionController::Base
  protect_from_forgery

  # Force signout to prevent CSRF attacks
  def handle_unverified_request
    sign_out
    super
  end

  private

    def deny
      redirect_to root_url, alert: t('.not_authorized') if signed_in?
    end

    # def authorize
    #   redirect_to root_url, alert: t('.not_authorized') unless signed_in?
    # end

    # A cookie that does not have an expiry will automatically be expired by
    # the browser when browser's session is finished.
    # cookies.permanent sets the expiry to 20 years
    # Booleans seem to get passed from forms as strings
    def sign_in(user)
      if remember_me
        cookies.permanent[:authentication_token] = user.authentication_token
      else
        cookies[:authentication_token] = user.authentication_token
      end
      self.current_user = user
    end
    helper_method :sign_in

    def remember_me
      params[:session].try(:[], :remember_me) == "true" ||
        params[:remember_me] == "true"
    end

    def signed_in?
      !current_user.nil?
    end
    helper_method :signed_in?

    def sign_out
      self.current_user = nil
      cookies.delete(:authentication_token)
    end
    helper_method :sign_out

    def current_user
      @current_user ||=
        User.find_by_authentication_token(cookies[:authentication_token])
    end
    helper_method :current_user

    def current_user=(user)
      @current_user = user
    end
    helper_method :current_user=

    # def current_user?(user)
    #   user == current_user
    # end
    # helper_method :current_user?

    # def signed_in_user
    #   unless signed_in?
    #     store_location # to redirect to original page after signin
    #     redirect_to signin_url, notice: t('flash.signin')
    #   end
    # end

    # def store_location
    #   session[:return_to] = request.url
    # end
    # helper_method :store_location
end