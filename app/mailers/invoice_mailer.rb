# frozen_string_literal: true
class InvoiceMailer < ActionMailer::Base
  layout 'mailer_html'
  def send_invoice(rental)
    @rental = rental
    attachments['Recharge V04.pdf'] = File.read("#{Rails.root}/app/assets/pdfs/Recharge V04.pdf")
    mail(to: rental.renter.email, subject: "Invoice for Rental #{rental.basic_info}", template_name: 'invoice')
  end
end
