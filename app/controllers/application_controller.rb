class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

	include ApplicationHelper
  include SessionsHelper

  before_action :current_user
  before_action :current_user_no_shibboleth
  before_action :has_permission?

  # Set auto papertrail
  before_filter :set_paper_trail_whodunnit

  def root
    redirect_to home_index_path
  end

  unless Rails.application.config.consider_all_requests_local
    rescue_from RuntimeError, Exception, with: :render_500
  end

  def render_404
    respond_to do |format|
      format.html { render template: 'errors/404.html.erb', status: 404 }
      format.all { render nothing: true, status: 404 }
    end
  end

  def render_500(error)
    #make sure to log the error
    logger.error error.message
    logger.error error.backtrace.join("\n")

    #send email to IT
    user = @current_user.username rescue "unknown"
    ErrorMailer.send_mail('parking-it@admin.umass.edu', request.fullpath(), user, error).deliver_now

    respond_to do |format|
      format.html { render template: 'errors/500.html.erb', status: 500 }
      format.all { render nothing: true, status: 500 }
    end
  end

  private

  def current_user
    if Rails.env.production? || Rails.env.staging?
      if request.env['fcIdNumber']
        spire = request.env['fcIdNumber'].split("@").first
        eppn = request.env['eppn'].split("@").first
        @current_user = User.find_by(spire: spire, username: eppn)
        if @current_user
          session[:user_id] = @current_user.id
        end
      elsif session[:user_id]
        @current_user = User.find(session[:user_id])
      end

      unless @current_user
        raise 'Please make this a view'
      end
    end
  end

  # def has_permission?
  #   if Rails.env.test?
  #     true
  #   elsif @current_user && (params[:action] == "render_404" || @current_user.has_permission?(params[:controller], params[:action], params[:id]))
  #     true
  #   else
  #     flash[:warning] = "Your account does not have access to this page."
  #     begin
  #       redirect_to :back
  #     rescue ActionController::RedirectBackError
  #       redirect_to root_path
  #     end
  #   end
  # end

  def current_user_no_shibboleth
    if Rails.env.development?
      @current_user = User.first
      session[:user_id] = @current_user.id
    end
  end

  # Makes sure the user is logged in
  # redirects:: to login page with an error if noone is logged in
  def require_login #:doc:
    if false
    unless logged_in?
      session[:return_to] = request.fullpath
      flash[:error] = "You must be logged in to access this page."
      redirect_to new_session_path
    end
    end
  end
end
