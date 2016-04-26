class ErrorMailer < ActionMailer::Base
  def error_email(email, path, user, error)
    @path = path
    @user = user
    @type = error.class
    @message = error.message
    @trace = error.backtrace

    @host = Rails.env.production? ? 'hub.parking.umass.edu' : 'localhost:3000'

    subject = "Probable-Engine Error Occured #{Time.zone.now}"
    mail(to: email, subject: subject)
  end
end
