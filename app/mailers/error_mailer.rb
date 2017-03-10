# frozen_string_literal: true
class ErrorMailer < ActionMailer::Base
  def error_email(email, path, user, serializable_error)
    # error must be serializable in order to use ActionMailer's deliver_later
    @path = path
    @user = user
    @type = serializable_error.class
    @message = serializable_error.message
    @trace = serializable_error.trace

    @host = Rails.env.production? ? 'hub.parking.umass.edu' : 'localhost:3000'

    subject = "Probable-Engine Error Occured #{Time.zone.now}"
    mail(to: email, subject: subject)
  end
end
