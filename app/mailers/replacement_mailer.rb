# frozen_string_literal: true
class ReplacementMailer < ActionMailer::Base
  def replacement_email(user, hold, old_rental, new_rental)
    @hold = hold
    @old_rental = old_rental
    @new_rental = new_rental

    mail(to: user.email, subject: 'Parking Services: Replacement of reserved Golf Cart(s)')
  end

  def no_replacement_email(user, hold, rental)
    @hold = hold
    @rental = rental

    mail(to: user.email, subject: 'Parking Services: Cancellation of reserved Golf Cart(s)')
  end
end
