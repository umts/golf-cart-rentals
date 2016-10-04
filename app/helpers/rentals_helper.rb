# frozen_string_literal: true
module RentalsHelper
  def numberify(input)
    number_to_phone(input.gsub(/[\s+)(-]/, ""), area_code: true)
  end
end
