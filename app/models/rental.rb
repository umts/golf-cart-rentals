class Rental < ActiveRecord::Base
  include AASM
  has_many :financial_transactions

  aasm column: :rental_status do
    state :reserved, initial: true
    state :checked_out
    state :checked_in
    state :inspected
    state :available
    state :canceled

    event :cancel do
      transitions from: :reserved, to: :canceled
    end

    event :pickup do
      transitions from: :reserved, to: :checked_out
      after do
        update(checked_out_at: Time.zone.now)
      end
    end

    event :return do
      transitions from: :checked_out, to: :checked_in
      after do
        update(checked_in_at: Time.zone.now)
      end
    end

    event :inspect do
      transitions from: :checked_in, to: :inspected
    end

    event :process do
      transitions from: [:inspected, :canceled], to: :available
    end
  end
end
