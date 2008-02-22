class Project < ActiveRecord::Base
  include ModelHelpers
  include EVMFormulas
  
  has_many :tasks, :dependent => :destroy
  
  validates_presence_of :name, :start_date, :end_date, :total_budget
  validates_numericality_of :total_budget,
                            :greater_than_or_equal_to => 1.00
  validates_uniqueness_of :name
  
  def self.find_most_recent
    find(:all, :limit => 10, :order => "updated_at DESC")
  end
  
  def allocated_budget
    tasks.sum(:budget)
  end
  
  def status(date)
    actual_completed = 0
    actual_spent = 0
    planned = 0
    
    tasks.each do |task|
      monthly_detail = task.monthly_details.find_by_date(date)
      
      if !monthly_detail.nil?
        actual_completed += monthly_detail.actual_completed_in_dollars if !monthly_detail.actual_completed_in_dollars.nil?
        actual_spent += monthly_detail.actual_spent_in_dollars if !monthly_detail.actual_spent_in_dollars.nil?
        planned += monthly_detail.planned_complete_in_dollars if !monthly_detail.planned_complete_in_dollars.nil?
      end
    end
    
    cpi = evm_cost_performance_index(actual_completed, actual_spent)
    spi = evm_schedule_performance_index(actual_completed, planned)
    evm_status(cpi, spi)
  end
  
  def update_end_date(date)
    if(date > end_date)
      update_attribute(:end_date, date)
    end
  end
  
  protected
  
  def validate
    # make sure the start date is before the end date the end date is after the start date
    if !start_date.nil? and !end_date.nil?
      validate_dates_not_swapped(errors, start_date, end_date)
    end
  end
end
