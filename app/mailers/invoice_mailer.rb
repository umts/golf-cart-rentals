class InvoiceMailer < ActionMailer::Base
  def send_invoice(rental)
    @rental = rental
    mail(to: rental.renter.email, subject: "Invoice for Rental #{rental.basic_info}", template_name: 'invoice')
  end
end
