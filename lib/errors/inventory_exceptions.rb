module InventoryExceptions
  class AuthError < StandardError; end # 401 unauth
  class InventoryError < StandardError; end # 500 server error or anything remaining

  class ItemTypeError < InventoryError; end
  class ItemError < InventoryError; end
  class ReservationError < InventoryError; end

  class ItemTypeNotFound < ItemTypeError; end # 404 not found
  class ReservationNotFound < ReservationError; end
  class ItemNotFound < ItemError; end

  class ReservationNotAvailable < ReservationError; end
  class InvalidUpdateReservationTime < ReservationError; end
  class InvalidUpdateReservationMetadata < ReservationError; end

  class InvalidUpdateItemTypeMetadata < ItemTypeError; end
  class InvalidItemTypeCreation < ItemTypeError; end

  class InvalidItemCreation < ItemError; end
  class InvalidUpdateItem < ItemError; end
end
