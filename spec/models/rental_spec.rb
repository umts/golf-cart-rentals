# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Rental do
  describe '#validations' do
    it 'is invalid without a renter_id' do
      expect(build(:rental, renter_id: nil)).not_to be_valid
    end
    it 'is invalid without a creator_id' do
      expect(build(:rental, creator_id: nil)).not_to be_valid
    end
    it 'is invalid without any items' do
      rental = create(:rental)
      rental.rentals_items = []
      expect(rental).not_to be_valid
    end
    it 'is invalid without a start_time' do
      expect(build(:rental, start_time: nil)).not_to be_valid
    end
    it "doesn't allow a zero day rental" do
      time = Time.current
      rent = build(:mock_rental, start_time: time, end_time: time)
      expect(rent).not_to be_valid
    end
    it 'is invalid without a end_time' do
      expect(build(:rental, end_time: nil)).not_to be_valid
    end
    it 'does not allow duplicate reservation_id' do
      rental = create :mock_rental
      expect(build(:rental, rentals_items: [build(:rentals_item, reservation_id: rental.reservation_ids.first)])).not_to be_valid
    end
    context 'start time before today' do
      it 'is invalid with a start_time before today' do
        expect(build(:rental, start_time: Time.zone.yesterday)).not_to be_valid
      end

      context 'time travel' do
        it 'is valid if it is persisted' do
          rental = create(:rental, start_time: Time.zone.today, end_time: Time.zone.tomorrow)
          Timecop.travel(4.days.from_now) # rental.start_time is before today
          expect(rental).to be_valid
        end

        after do
          Timecop.return
        end
      end
    end
    it 'is invalid with an end_time before the start_time' do
      expect(build(:rental, start_time: Time.zone.tomorrow, end_time: Time.zone.today)).not_to be_valid
    end

    context 'renter_is_assignable' do
      before do
        User.destroy_all
        @dept_one = create :department
        @dept_one_users = create_list :user, 10, department: @dept_one
        @other_users = create_list :user, 10 # not in @dept_one
      end

      it 'allows assignment of user inside dept w/o perm' do
        expect(build(:mock_rental, creator: @dept_one_users.first, renter: @dept_one_users.second)).to be_valid
      end

      it 'allows assignment of user outside dept with permission' do
        u = @other_users.first
        g = create(:group)
        g.permissions << create(:permission, controller: 'rentals', action: 'assign_anyone')
        g.save
        u.groups << g
        u.save
        # renter is outside dept but has permissions
        expect(create(:mock_rental, creator: u, renter: @dept_one_users.first)).to be_valid
      end

      it 'denies outside deparment' do
        r = build(:mock_rental, creator: @other_users.first, renter: @dept_one_users.first)
        expect(r).not_to be_valid
        expect(r.errors[:renter].size).to eq(1)
      end
    end
  end

  describe 'scope' do
    it 'finds rented by and created by' do
      g = create :group
      g.permissions << create(:permission, controller: 'rentals', action: 'assign_anyone')
      g.save
      creator = create :user, groups: [g]
      creator_two = create :user, groups: [g]
      renter = create :user
      renter_two = create :user
      rentals_one = create_list :mock_rental, 4, creator: creator, renter: renter_two
      rentals_two = create_list :mock_rental, 4, renter: renter, creator: creator_two
      expect(Rental.created_by(creator)).to eq rentals_one
      expect(Rental.created_by(renter)).to be_empty
      expect(Rental.rented_by(renter)).to eq rentals_two
      expect(Rental.rented_by(creator)).to be_empty
    end

    it 'with_balance_due' do
      # create our mock rentals
      rental_paid = create :mock_rental
      rental_unpaid = create :mock_rental # unpaid

      # get amount from the transaction created by rental
      amount = rental_paid.balance

      # pay for rental
      create :financial_transaction, :with_payment, amount: amount, rental: rental_paid
      # now rental_paid has no balance due

      expect(Rental.with_balance_due).to contain_exactly rental_unpaid
    end

    it 'with_balance_over' do
      rental_expensive = create :mock_rental, rentals_items: [build(:rentals_item, item_type: (create :item_type, base_fee: 1000, fee_per_day: 0))]
      create :mock_rental, rentals_items: [build(:rentals_item, item_type: (create :item_type, base_fee: 900, fee_per_day: 0))]
      rental_paid = create :mock_rental
      create :mock_rental # unpaid

      # get amount from the transaction created by rental
      amount = rental_paid.balance

      # pay for rental
      create :financial_transaction, :with_payment, amount: amount, rental: rental_paid
      # now rental_paid has no balance due

      # that unpaid rental doesnt meet the minimum balance over
      expect(Rental.with_balance_over(900)).to contain_exactly rental_expensive
    end
  end

  describe '#create_rental' do
    it 'creates a rental with valid parameters' do
      @rent = create :mock_rental
      expect(@rent).to be_valid
      expect(Rental.find(@rent.id)).to eq(@rent)
    end

    it 'creates associated reservation' do
      # mock up the api so it doesnt make it for realzies
      allow(Inventory).to receive(:create_reservation).and_return(uuid: '42', item: { name: create(:item).name })

      rental = create :rental
      expect(rental).to be_reserved
      expect(rental.reservation_ids).to contain_exactly '42'
    end

    it 'doesnt create a rental if the reservation fails' do
      allow(Inventory).to receive(:create_reservation).and_return({})

      expect do
        (build :rental).save
      end.not_to change(Rental, :count)
    end

    it 'doesnt create a rental if the reservation thows an error' do
      # generic exception
      allow(Inventory).to receive(:create_reservation).and_raise(StandardError)

      expect do
        (build :rental).save
      end.not_to change(Rental, :count)
    end

    it 'accepts nested attributes' do
      expect { create :rental, rentals_items_attributes: [{ item_type: create(:item_type) }, { item_type: create(:item_type) }] }.to change(Rental, :count).by 1
    end

    context 'rolls reservation if any reservations fail to create' do
      let(:fail_rentals_item) { build(:rentals_item, reservation_id: nil) }
      before(:each) do
        # fail on one reservation but not the other
        allow(Inventory).to receive(:create_reservation).with(fail_rentals_item.item_type.name, anything, anything).and_raise(StandardError)
      end

      it 'rolls back other reservations if a single reservation fails' do
        expect do
          create(:rental, rentals_items: [build(:rentals_item, reservation_id: nil), fail_rentals_item])
        end.to(raise_error(ActiveRecord::RecordNotSaved)) && change(Rental, :count).by(0) && change(RentalsItem, :count).by(0)
        expect(Inventory).to have_received(:delete_reservation).once # will only be called for the one that works
      end

      it 'adds to errors if it fails to delete reservation' do
        # will try to roll back but we wont let it
        allow(Inventory).to receive(:delete_reservation).and_raise(StandardError)

        r = build(:rental, rentals_items: [build(:rentals_item, reservation_id: nil), fail_rentals_item])
        expect do
          r.save!
        end.to(raise_error(ActiveRecord::RecordNotSaved)) && change(Rental, :count).by(0) && change(RentalsItem, :count).by(0)
        messages = r.errors.messages[:base]
        expect(messages.count).to eq 2

        # expect messages to contain 'partially rolled back' and 'failed to delete reservations from api'
        expected_message = /Failed to delete reservations from inventory api /
        expect(expected_message.match(messages.first).nil? ^ expected_message.match(messages.second).nil?).to eq(true)
        expected_message = /Reservations partially rolled back /
        expect(expected_message.match(messages.first).nil? ^ expected_message.match(messages.second).nil?).to eq(true)
      end
    end
  end

  describe '#delete_rental' do
    before :each do
      @rent = create :mock_rental
    end

    it 'deletes a rental properly' do
      expect do
        @rent.destroy
      end.to change { Rental.count }.by(-1)
    end
  end

  describe '#cost' do
    it 'gets the right cost based on item types' do
      it1 = create :item_type, base_fee: 5, fee_per_day: 2
      it2 = create :item_type, base_fee: 3, fee_per_day: 11
      rental = build :rental, start_time: Time.zone.today, end_time: Time.zone.tomorrow,
                              rentals_items_attributes: [{ item_type: it1 }, { item_type: it2 }]
      # cost is base_fee + duration (days) * fee_per_day
      expect(rental.cost).to eq((5 + 2 * 2) + (3 + 2 * 11))
    end
  end

  describe '#times' do
    before :each do
      @rental = create :mock_rental
    end

    it 'returns a string with times' do
      expect(@rental.times).to be_a(String)
      expect(@rental.dates).to be_a(String)
    end
  end

  describe '#balance' do
    before :each do
      @rental = create :mock_rental
    end

    it 'return the sum of all @rental\'s financial transation amounts' do
      sum_amount = FinancialTransaction.where(rental: @rental).map(&:amount).inject(:+)
      expect(@rental.balance).to eq(sum_amount)
    end

    it 'returns the cost-payments' do
      sum_amount = @rental.financial_transactions.where.not(transactable_type: Payment.name).sum(:amount)
      create(:financial_transaction, transactable: create(:payment), amount: sum_amount, rental: @rental)

      expect(@rental.balance).to be_zero # fully paid
    end

    it 'handles a cancelation' do
      sum_amount = @rental.financial_transactions.where.not(transactable_type: Payment.name).sum(:amount)
      create(:financial_transaction, transactable_type: Cancelation.name, amount: sum_amount, rental: @rental)

      expect(@rental.balance).to be_zero # fully paid, because it was canceled
    end
  end

  describe 'rental_status' do
    before :each do
      @rental = create :mock_rental
    end

    it 'is reserved upon creation' do
      expect(@rental).to be_reserved
    end

    context 'cancelation' do
      it 'changes state to canceled' do
        @rental.cancel!
        expect(@rental).to be_canceled
      end

      it 'creates a cancelation ft' do
        expect do
          @rental.cancel!
        end.to change(FinancialTransaction, :count).by(1)
      end

      it 'is zero balanced' do
        @rental.cancel!
        expect(@rental.balance).to be_zero
      end
    end

    it 'is picked_up after pickup' do
      @rental.pickup!
      expect(@rental.picked_up_at).not_to be_nil
      expect(@rental).to be_picked_up
    end

    it 'is dropped_off after return' do
      @rental.pickup
      @rental.drop_off!
      expect(@rental.dropped_off_at).not_to be_nil
      expect(@rental).to be_dropped_off
    end

    it 'is canceled after being processed as a no show' do
      @rental.process_no_show!
      expect(@rental).to be_canceled
    end

    it 'is inspected after approve' do
      @rental.pickup
      @rental.drop_off
      @rental.approve!
      expect(@rental).to be_inspected
    end

    it 'is available after process' do
      @rental.pickup
      @rental.drop_off
      @rental.approve
      @rental.process!
      expect(@rental).to be_available
    end
  end

  describe '#create_financial_transaction' do
    it '.create_financial_transaction callback is triggered on create' do
      rental = build(:rental)
      # Critical section.
      Mutex.new.synchronize do
        expect(rental).to receive(:create_financial_transaction)
        rental.save
      end
    end
    it 'creates a finacial transaction based on the item_type' do
      rental = build(:rental)
      expect(rental.financial_transaction).to be(nil)
      rental.save
      expect(rental.financial_transaction).to be_an_instance_of(FinancialTransaction)
    end
    it 'wont create a financial_transaction if told not to' do
      rental = build :rental, skip_financial_transactions: true
      expect { rental.save }.not_to change(FinancialTransaction, :count)
    end
  end

  describe '#event_status_color' do
    before :each do
      @rental = create :mock_rental
    end
    it 'returns #0092ff when reserved' do
      expect(@rental.event_status_color).to eq('#0092ff')
    end
    it 'returns #f7ff76 when picked_up' do
      @rental.rental_status = :picked_up
      expect(@rental.event_status_color).to eq('#f7ff76')
    end
    it 'returns #09ff00 when dropped_off' do
      @rental.rental_status = :dropped_off
      expect(@rental.event_status_color).to eq('#09ff00')
    end
    it 'returns #ff0000 when cancelled' do
      @rental.rental_status = :canceled
      expect(@rental.event_status_color).to eq('#ff0000')
    end
    it 'returns #000000 when approved' do
      @rental.rental_status = :inspected
      expect(@rental.event_status_color).to eq('#000000')
    end
    it 'returns #000000 when processed' do
      @rental.rental_status = :available
      expect(@rental.event_status_color).to eq('#000000')
    end
  end

  describe '#str_item_types' do
    it 'returns basic info of new rental' do
      rental = create :mock_rental
      expect(rental.str_item_types).to eq(rental.item_types.first.name)
    end

    it 'returns a list of item types if there are multiple items' do
      rental = create :mock_rental, rentals_items: build_list(:rentals_item, 2)
      expect(rental.str_item_types).to eq("#{rental.item_types.first.name}, #{rental.item_types.second.name}")
    end
  end

  describe '#basic_info' do
    it 'returns basic info of single item rental' do
      rental = create :mock_rental
      expect(rental.basic_info).to eq("#{rental.item_types.first.name}:(#{rental.start_time.to_date} -> #{rental.end_time.to_date})")
    end

    it 'returns a list of item types if there are multiple' do
      rental = create :mock_rental, rentals_items: build_list(:rentals_item, 2)
      expect(rental.basic_info).to eq("#{rental.str_item_types}:(#{rental.start_time.to_date} -> #{rental.end_time.to_date})")
    end
  end

  describe '#event_name' do
    it 'returns event name of single item rental' do
      rental = create :mock_rental
      expect(rental.event_name).to eq("#{rental.item_types.first.name}(#{rental.item_types.first.id}) - Rental ID: #{rental.id}")
    end

    # it calls the same method as used in basic_info no reason to test multiple as well
  end

  describe '#payments' do
    it 'returns payments for that rental' do
      rental = create :rental
      one = create :financial_transaction, :with_payment, amount: 1, rental: rental
      two = create :financial_transaction, :with_payment, amount: 1, rental: rental
      expect(rental.payments).to contain_exactly one, two
    end
  end

  describe '#department' do
    it 'delegates to renter' do
      rental = create :mock_rental
      expect(rental.department).to eq(rental.renter.department)
    end
  end

  context 'rentals and financial transactions' do
    it 'creates a 1 day financial transaction' do
      rent = create :mock_rental, end_time: (Time.current + 1.second)
      expect(FinancialTransaction.where(rental: rent).map(&:amount)).to eq([110])
    end
    it 'creates a 2 day financial transaction' do
      rent = create :mock_rental
      expect(FinancialTransaction.where(rental: rent).map(&:amount)).to eq([120])
    end
    it 'creates a 3 day financial transaction' do
      rent = create :mock_rental, end_time: (Time.current + 2.days)
      expect(FinancialTransaction.where(rental: rent).map(&:amount)).to eq([130])
    end
    it 'creates a 7 day financial transaction(1 day free)' do
      rent = create :mock_rental, end_time: (Time.current + 6.days)
      expect(FinancialTransaction.where(rental: rent).map(&:amount)).to eq([160])
    end
    it 'creates a 8 day financial transaction(1 day free)' do
      rent = create :mock_rental, end_time: (Time.current + 7.days)
      expect(FinancialTransaction.where(rental: rent).map(&:amount)).to eq([170])
    end
    it 'creates a 15 day financial transaction(2 days free)' do
      rent = create :mock_rental, end_time: (Time.current + 14.days)
      expect(FinancialTransaction.where(rental: rent).map(&:amount)).to eq([230])
    end
    it 'creates a 2 day financial transaction with different fees' do
      rent = create :mock_rental, rentals_items: [build(:rentals_item, item_type: create(:item_type, name: 'Test 220', base_fee: 200, fee_per_day: 20))]
      expect(FinancialTransaction.where(rental: rent).map(&:amount)).to eq([240])
    end
    let!(:four_seat) { create(:item_type, name: '4 Seat') }
    it 'creates a 4 Seat 14 day financial transaction(longterm 2 week)' do
      rent = create :mock_rental, rentals_items: [build(:rentals_item, item_type: four_seat)], end_time: (Time.current + 13.days)
      expect(FinancialTransaction.where(rental: rent).map(&:amount)).to eq([500])
    end
    it 'creates a 4 Seat 21 day financial transaction(longterm 3 week)' do
      rent = create :mock_rental, rentals_items: [build(:rentals_item, item_type: four_seat)], end_time: (Time.current + 20.days)
      expect(FinancialTransaction.where(rental: rent).map(&:amount)).to eq([700])
    end
    it 'creates a 4 Seat 28 day financial transaction(longterm 4 week)' do
      rent = create :mock_rental, rentals_items: [build(:rentals_item, item_type: four_seat)], end_time: (Time.current + 27.days)
      expect(FinancialTransaction.where(rental: rent).map(&:amount)).to eq([850])
    end
    let!(:six_seat) { create(:item_type, name: '6 Seat') }
    it 'creates a 6 Seat 14 day financial transaction(longterm 2 week)' do
      rent = create :mock_rental, rentals_items: [build(:rentals_item, item_type: six_seat)], end_time: (Time.current + 13.days)
      expect(FinancialTransaction.where(rental: rent).map(&:amount)).to eq([600])
    end
    it 'creates a 6 Seat 21 day financial transaction(longterm 3 week)' do
      rent = create :mock_rental, rentals_items: [build(:rentals_item, item_type: six_seat)], end_time: (Time.current + 20.days)
      expect(FinancialTransaction.where(rental: rent).map(&:amount)).to eq([900])
    end
    it 'creates a 6 Seat 28 day financial transaction(longterm 4 week)' do
      rent = create :mock_rental, rentals_items: [build(:rentals_item, item_type: six_seat)], end_time: (Time.current + 27.days)
      expect(FinancialTransaction.where(rental: rent).map(&:amount)).to eq([1100])
    end
  end

  describe '#delete_reservation' do
    context 'error thrown' do
      it 'logs the error and returns false' do
        r = create(:mock_rental)
        allow(Inventory).to receive(:delete_reservation).and_raise(InventoryExceptions::AuthError)
        expect do
          r.destroy # will call delete reservation before_destroy
        end.not_to change(Rental, :count)
        expect(r.errors.count).to be 1
        expect(r.errors[:rentals_items].first).to match(/Failed to delete reservation \(uuid /)
      end
    end
  end
end
