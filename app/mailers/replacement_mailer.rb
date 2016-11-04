class ReplacementMailer < ActionMailer::Base

  def replacement_email(user, hold, old_rental, new_rental)
    @user = user
    @hold = hold
    @old_rental = old_rental
    @new_rental = new_rental

    mail(to: @user.email, subject: 'Your reserved Golf cart has been replaced')
  end

  def no_replacement_email(user, hold, rental)
    @user = user
    @hold = hold
    @rental = rental

    mail(to: @user.email, subject: 'Your reserved Golf cart has been cancelled')
  end
end
