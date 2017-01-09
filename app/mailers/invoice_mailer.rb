class ReplacementMailer < ActionMailer::Base
  def send_invoice(user, rental)
    @rental = rental
    mail(to: user.email, subject: "Invoice for Rental #{rental.basic_info}", template_name: 'rentals/invoice')
  end
end
