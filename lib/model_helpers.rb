module ModelHelpers
  def validate_dates_not_swapped(errors, start_date, end_date)
    if(start_date > end_date)
      errors.add_to_base("The start date can't be after the end date")
      errors.add(:start_date)
      errors.add(:end_date)
    end
  end
end 