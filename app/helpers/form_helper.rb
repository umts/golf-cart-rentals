module FormHelper
  def setup_incurred_incidental(incurred_incidental)
    incurred_incidental.notes.build
    incurred_incidental
  end
end
