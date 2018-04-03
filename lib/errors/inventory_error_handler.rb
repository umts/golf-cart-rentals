module InventoryErrorHandler
  def self.included(klass)
    klass.class_eval do
      rescue_from InventoryExceptions::AuthError, with: :error_response
      rescue_from InventoryExceptions::InventoryError, with: :error_response

      rescue_from InventoryExceptions::ItemTypeError, with: :error_response
      rescue_from InventoryExceptions::InvalidItemTypeCreation, with: :error_response
      rescue_from InventoryExceptions::InvalidUpdateItemTypeMetadata, with: :error_response
      rescue_from InventoryExceptions::ItemTypeNotFound, with: :error_response

      rescue_from InventoryExceptions::ItemError, with: :error_response
      rescue_from InventoryExceptions::InvalidItemCreation, with: :error_response
      rescue_from InventoryExceptions::InvalidUpdateItem, with: :error_response
      rescue_from InventoryExceptions::ItemNotFound, with: :error_response

      rescue_from InventoryExceptions::ReservationError, with: :error_response
      rescue_from InventoryExceptions::ReservationNotAvailable, with: :error_response
      rescue_from InventoryExceptions::InvalidUpdateReservationTime, with: :error_response
      rescue_from InventoryExceptions::InvalidUpdateReservationMetadata, with: :error_response
      rescue_from InventoryExceptions::ReservationNotFound, with: :error_response
    end
  end

  private

  def error_response(e)
   render template: 'errors/inventory_exception.html.erb',
          locals: { error_class: e.class, error_message: e.message },
          status: 500
  end

end
