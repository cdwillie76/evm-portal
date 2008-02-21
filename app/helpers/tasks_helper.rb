module TasksHelper
  def add_task_link(name)
    link_to_function name do |page|
      page.insert_html :bottom, :monthly_details, :partial => 'monthly_detail', :object => MonthlyDetail.new
    end
  end
end
