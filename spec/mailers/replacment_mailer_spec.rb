require "rails_helper"

RSpec.describe ReplacementMailer, type: :mailer do
  let(:replacement_mail) {
    rental = create :mock_rental
    hold = create :hold, item: rental.items.first, item_type: rental.item_types.first
    ReplacementMailer.replacement_email(User.first, hold, rental, create(:mock_rental))
  }

  let(:no_replacement_mail) {
    rental = create :mock_rental
    hold = create :hold, item: rental.items.first, item_type: rental.item_types.first
    ReplacementMailer.no_replacement_email(User.first, hold, rental)
  }

  it 'sends a replacement email' do
    expect do
      replacement_mail.deliver_now
    end.to change { ActionMailer::Base.deliveries.count }.by(1)
  end

  it 'sends a no replacement email' do
    expect do
      no_replacement_mail.deliver_now
    end.to change { ActionMailer::Base.deliveries.count }.by(1)
  end
end
