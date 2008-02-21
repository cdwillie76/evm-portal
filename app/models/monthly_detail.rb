class MonthlyDetail < ActiveRecord::Base
  include EVMFormulas
  
  belongs_to :task
  
  # dynamically define the methods to get/set based on percent complete for both the
  # actual and planned values
  methods = { :planned => 'complete', :actual => 'completed' }

  methods.each do |type, verb|
    define_method("#{type}_percent_complete") do
      return 0 if send("#{type}_#{verb}_in_dollars").nil?
        ((send("#{type}_#{verb}_in_dollars").to_f / task.budget.to_f) * 100).round(2)
    end

    define_method("#{type}_percent_complete=") do |pc|
      send "#{type}_#{verb}_in_dollars=", (pc.to_i / 100.0) * task.budget
    end
  end
  
  # EVM Formulas 
  def cost_variance
    evm_cost_variance(self.actual_completed_in_dollars, self.actual_spent_in_dollars)
  end
  
  def cost_performance_index
    evm_cost_performance_index(self.actual_completed_in_dollars, self.actual_spent_in_dollars)
  end
  
  def schedule_variance
    evm_schedule_variance(self.actual_completed_in_dollars, self.planned_complete_in_dollars)
  end
  
  def schedule_performance_index
    evm_schedule_performance_index( self.actual_completed_in_dollars, self.planned_complete_in_dollars)
  end
  
  def estimate_to_completion
    evm_estimate_to_completion(self.task.budget, self.actual_completed_in_dollars)
  end
  
  def estimate_at_completion
    evm_estimate_at_completion(self.task.budget, self.cost_performance_index)                  
  end
  
  def variance_at_completion
    evm_variance_at_completion(self.task.budget, self.estimate_at_completion)
  end
  
  def status
    evm_status(self.cost_performance_index, self.schedule_performance_index)
  end
end