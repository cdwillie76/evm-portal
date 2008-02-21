# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def day_year_date_select(form, field)
    form.date_select(field, :discard_day => true)
  end
end
