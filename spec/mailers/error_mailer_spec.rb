# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ErrorMailer, type: :mailer do
  let(:mail) do
    err = nil
    # needs to be a legit error (not just StandardError.new) so we can have a backtrace
    begin
      raise StandardError
    rescue => std_error
      err = std_error
    end
    serializable_error = { class: err.class.to_s, message: err.message, trace: err.backtrace }
    ErrorMailer.error_email('test@test.host', '/page_that_causes_error?param=one', User.first, serializable_error)
  end

  it 'can send an email' do
    expect do
      mail.deliver_now
    end.to change { ActionMailer::Base.deliveries.count }.by(1)
  end
end
