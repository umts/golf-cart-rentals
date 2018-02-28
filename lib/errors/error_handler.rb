module ErrorHandler
  def self.included(class)
    class.class_eval do
      rescue_from InventoryExceptions::AuthError, with:
      rescue_from InventoryExceptions::InventoryError, with:

      rescue_from InventoryExceptions::ItemTypeError, with:
      rescue_from InventoryExceptions::InvalidItemTypeCreation, with:
      rescue_from InventoryExceptions::InvalidUpdateItemTypeMetadata, with:
      rescue_from InventoryExceptions::ItemTypeNotFound, with:

      rescue_from InventoryExceptions::ItemError, with:
      rescue_from InventoryExceptions::InvalidItemCreation, with:
      rescue_from InventoryExceptions::InvalidUpdateItem, with:
      rescue_from InventoryExceptions::ItemNotFound, with:

      rescue_from InventoryExceptions::ReservationError, with:
      rescue_from InventoryExceptions::ReservationNotAvailable, with:
      rescue_from InventoryExceptions::InvalidUpdateReservationTime, with:
      rescue_from InventoryExceptions::InvalidUpdateReservationMetadata, with:
      rescue_from InventoryExceptions::ReservationNotFound, with:
    end
  end
end
