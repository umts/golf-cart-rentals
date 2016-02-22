class Rental < ActiveRecord::Base
  include AASM

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
        self.checked_out_at = DateTime.now
      end
    end

    event :return do
      transitions from: :checked_out, to: :checked_in
      after do
        self.checked_in_at = DateTime.now
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
