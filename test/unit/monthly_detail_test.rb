require File.dirname(__FILE__) + '/../test_helper'

class MonthlyDetailTest < ActiveSupport::TestCase
  
  fixtures :projects
  fixtures :tasks
  fixtures :monthly_details
  
  def test_status_green
    monthly_detail = monthly_details(:monthly_detail_green)
    
    assert_equal monthly_detail.status, "Green - 1.0"
  end
  
  def test_status_yellow
    monthly_detail = monthly_details(:monthly_detail_yellow)
    
    assert_equal monthly_detail.status, "Yellow - 0.9"
  end
  
  def test_status_red
    monthly_detail = monthly_details(:monthly_detail_red)
    
    assert_equal monthly_detail.status, "Red - 0.7"
  end
  
  def test_status_black
    monthly_detail = monthly_details(:monthly_detail_black)
    
    assert_equal monthly_detail.status, "Black - 0.5"
  end
  
  def test_status_nan
    monthly_detail = monthly_details(:monthly_detail_empty)
    
    assert_equal monthly_detail.status, "N/A"
  end
  
  def test_planned_percent_complete
    monthly_detail = monthly_details(:monthly_detail_empty)
    assert_equal monthly_detail.planned_percent_complete, 0
    
    monthly_detail.planned_percent_complete = 1.0
    assert_equal monthly_detail.planned_percent_complete, 1.0
    
    monthly_detail = monthly_details(:monthly_detail_yellow)
    assert_equal monthly_detail.planned_percent_complete, 1.11
    
    
  end
  
  def test_actual_percent_complete
    monthly_detail = monthly_details(:monthly_detail_empty)
    assert_equal monthly_detail.actual_percent_complete, 0
    
    monthly_detail.actual_percent_complete = 1.0
    assert_equal monthly_detail.actual_percent_complete, 1.0
    
    monthly_detail = monthly_details(:monthly_detail_yellow)
    assert_equal monthly_detail.actual_percent_complete, 1.0
  end
  
  def test_cost_variance
    monthly_detail = monthly_details(:monthly_detail_yellow)
    assert_equal monthly_detail.cost_variance, -100
  end
  
  def test_schedule_variance
    monthly_detail = monthly_details(:monthly_detail_yellow)
    assert_equal monthly_detail.schedule_variance, -100
  end
  
  def test_estimate_to_completion
    monthly_detail = monthly_details(:monthly_detail_yellow)
    assert_equal monthly_detail.estimate_to_completion, 89100
  end
  
  def test_estimate_at_completion
    monthly_detail = monthly_details(:monthly_detail_yellow)
    assert_equal monthly_detail.estimate_at_completion, 100000
  end
  
  def test_variance_at_completion
    monthly_detail = monthly_details(:monthly_detail_yellow)
    assert_equal monthly_detail.variance_at_completion, -10000
  end
end
