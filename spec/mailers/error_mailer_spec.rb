require "rails_helper"

RSpec.describe ErrorMailer, type: :mailer do
  let(:mail) {
    err = nil
    # needs to be a legit error (not just StandardError.new) so we can have a backtrace
    begin
      raise StandardError
    rescue => std_error
      err = std_error
    end
    serializable_error = { class: err.class.to_s, message: err.message, trace: err.backtrace }
    ErrorMailer.error_email('test@test.host', '/page_that_causes_error?param=one', User.first, serializable_error)
  }

  it 'can send an email' do
    expect do
      mail.deliver_now
    end.to change { ActionMailer::Base.deliveries.count }.by(1)
  end

  it 'will send an email when a controller runs into a 500 error' do
    allow(HomeController).to receive(:index).and_raise(StandardError.new)
    get '/home'
  end


end
