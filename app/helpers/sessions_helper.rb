# frozen_string_literal: true
module SessionsHelper
  def logged_in?
    !@current_user.nil?
  end
end
