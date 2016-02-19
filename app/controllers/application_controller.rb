class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include ApplicationHelper
  include SessionsHelper

  before_action :current_user
  before_action :has_permission?

  # Set auto papertrail
  before_action :set_paper_trail_whodunnit

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
    # make sure to log the error
    logger.error error.message
    logger.error error.backtrace.join("\n")

    # send email to IT
    user = begin
             @current_user.username
           rescue
             'unknown'
           end
    ErrorMailer.send_mail('parking-it@admin.umass.edu', request.fullpath, user, error).deliver_now

    respond_to do |format|
      format.html { render template: 'errors/500.html.erb', status: 500 }
      format.all { render nothing: true, status: 500 }
    end
  end

  private

  def current_user
    # handle users approprately in production
    if Rails.env.production? || Rails.env.staging?

      # handle shibboleth login
      if request.env['fcIdNumber']
        spire_id = request.env['fcIdNumber'].split('@').first
        @current_user = User.find_by(spire_id: spire_id)
        session[:user_id] = @current_user.id if @current_user

      # handle user already logged in
      elsif session[:user_id]
        @current_user = User.find(session[:user_id])
      end

      # raise error if user failed to log in
      fail 'Error occured logging user in' unless @current_user

    # assign the first user when in development
    elsif Rails.env.development?
      @current_user = User.first
      session[:user_id] = @current_user.id
    end
  end

  def has_permission?
    # allow anyone in test
    if Rails.env.test?
      true

    # allow logged in users to view 404 and pages they have access to
    elsif @current_user && (params[:action] == 'render_404' || @current_user.has_permission?(params[:controller], params[:action], params[:id]))
      true

    # raise an error and redirect if the current user cannot view the page
    elsif @current_user
      flash[:warning] = 'Your account does not have access to this page.'
      begin
        redirect_to :back
      rescue ActionController::RedirectBackError
        redirect_to root_path
      end
    end
  end

  def self.get_actions(controller)
    controller.instance_methods(false).map(&:to_s) & controller.action_methods.to_a
  end
end
