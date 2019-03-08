# frozen_string_literal: true
class MissingUserError < StandardError; end
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include ApplicationHelper
  include SessionsHelper
  include InventoryExceptionsHandler

  before_action :current_user
  before_action :check_permission

  # Set auto papertrail
  before_action :set_paper_trail_whodunnit

  rescue_from ActiveRecord::RecordNotFound, with: :render_404 unless Rails.env.development?
  rescue_from MissingUserError, with: :render_401

  def root
    redirect_to home_index_path
  end

  def render_404
    respond_to do |format|
      format.html { render template: 'errors/404.html.erb', status: 404 }
      format.all { render body: nil, status: 404 }
    end
  end

  def render_401
    render template: 'errors/401.html.erb', layout: false, status: 401
  end

  def self.get_actions(controller)
    controller.instance_methods(false).map(&:to_s) & controller.action_methods.to_a
  end

  def current_user
    # handle users approprately in production
    if Rails.env.production? || Rails.env.staging?
      # try logging in user with shibboleth info
      user_from_shibboleth

      # try to retrieve user from session if didn't log in
      user_from_session if @current_user.nil?

      # raise error if user failed to log in
      raise MissingUserError unless @current_user

    # assign the first user when in development
    else
      @current_user ||= User.find_by(id: session[:user_id]) || User.first
      session[:user_id] = @current_user.try(:id)
    end
  end

  def has_permission?
    # allow anyone in test
    return true if Rails.env.test?

    # allow anyone to view the root and 404 pages
    return true if has_global_permission?

    # allow logged in users to view pages they have access to
    return true if @current_user &&
                   @current_user.has_permission?(params[:controller], params[:action], params[:id])

    # prevent users without permission
    false
  end

  private

  def check_permission
    return if has_permission?
    flash[:warning] = 'Your account does not have access to this page'
    redirect_back(fallback_location: home_index_path)
  end

  def user_from_shibboleth
    if request.env['fcIdNumber']
      spire_id = request.env['fcIdNumber'].split('@').first
      @current_user = User.active.find_by(spire_id: spire_id)
      session[:user_id] = @current_user.id if @current_user
    end
  end

  def user_from_session
    @current_user = User.active.find_by(id: session[:user_id]) if session[:user_id]
  end

  def has_global_permission?
    # allow anyone to access root and 404 page
    (params[:controller] == 'application' && params[:action] == 'root') ||
      (params[:controller] == 'home' && params[:action] == 'index') ||
      params[:action] == 'render_404'
  end
end
