module InventoryExceptions
  class AuthError < StandardError; end
  class InventoryError < StandardError
    #attr_reader :error
    #def initialize(error_response)
    #  @error = error_response
    #end
  end
  class ReservationNotAvailable < InventoryError; end
  class InvalidUpdateReservationTime < InventoryError; end
  class InvalidUpdateReservationMetadata < InventoryError; end
  class InvalidUpdateItemTypeMetadata < InventoryError; end
  class InvalidItemTypeCreation < InventoryError; end
  class InvalidItemCreation < InventoryError; end
  class InvalidUpdateItem < InventoryError; end
end
