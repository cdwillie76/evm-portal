module EVMFormulas
  def evm_cost_variance(actual_completed_in_dollars, actual_spent_in_dollars)
    actual_completed_in_dollars - actual_spent_in_dollars
  end
  
  def evm_cost_performance_index(actual_completed_in_dollars, actual_spent_in_dollars)
    actual_completed_in_dollars.to_f / actual_spent_in_dollars.to_f
  end
  
  def evm_schedule_variance(actual_completed_in_dollars, planned_complete_in_dollars)
    actual_completed_in_dollars - planned_complete_in_dollars
  end
  
  def evm_schedule_performance_index(actual_completed_in_dollars, planned_complete_in_dollars)
    actual_completed_in_dollars.to_f / planned_complete_in_dollars.to_f
  end
  
  def evm_estimate_to_completion(task_budget, actual_completed_in_dollars)
    task_budget - actual_completed_in_dollars
  end
  
  def evm_estimate_at_completion(task_budget, cost_performance_index)
    task_budget.to_f / cost_performance_index
  end
  
  def evm_variance_at_completion(task_budget, estimate_at_completion)
    task_budget - estimate_at_completion
  end
  
  def evm_status(cost_performance_index, schedule_performance_index)
    value = (cost_performance_index.to_f + schedule_performance_index.to_f)/2
    
    if value.nan?
      "N/A"
    elsif value >= 1.0
      "Green - #{value.round(2)}"
    elsif value >= 0.85
      "Yellow - #{value.round(2)}"
    elsif value >= 0.65
      "Red - #{value.round(2)}"
    else
      "Black - #{value.round(2)}"
    end
  end
end