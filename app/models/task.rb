#require "ModelHelpers"

class Task < ActiveRecord::Base
  include ModelHelpers
  
  belongs_to :project
  has_many :monthly_details, :dependent => :destroy
  
  validates_presence_of :name, :start_date, :end_date, :budget
  validates_numericality_of :budget
  validates_uniqueness_of :name, :scope => :project_id
  
  def status(date)
    monthly_detail = monthly_details.find_by_date(date)
    if !monthly_detail.nil?
      monthly_detail.status
    else
      "N/A"
    end
  end
  
  def extend_end_date
    md = monthly_details.find(:first, :order => "date DESC")
    new_date = md.date.next_month
    MonthlyDetail.create :date => new_date, :task_id => md.task_id,
      :planned_complete_in_dollars => md.planned_complete_in_dollars
    update_attribute(:end_date, new_date)
    project.update_end_date(new_date)
  end
  
  def complete_task
    date = self.end_date
    md = self.monthly_details.find(:first, :order => "date DESC")
    
    while date <= self.project.end_date
      unless monthly_details.exists?(:date => date)
        new_md = MonthlyDetail.new md.attributes
        new_md.id = nil
        new_md.date = date
        new_md.save
      end
      
      date = date.next_month
    end
    
    update_attribute(:completed, true)
  end
  
  def ready_to_be_completed?
    return_val = false
    md = self.monthly_details.find(:first, :order => "date DESC")
    
    if md.planned_complete_in_dollars == 0
      return_val = false
    else
      return_val = md.actual_completed_in_dollars == md.planned_complete_in_dollars
    end
    
    return return_val
  end
  
  protected
  
  after_save do |task|
    date = task.start_date
    
    while date <= task.end_date
      unless task.monthly_details.exists?(:date => date)
        MonthlyDetail.create :date => date, :task_id => task.id
      end
      date = date.next_month
    end
  end
  
  def validate
    if !project_id.nil?
      project = Project.find(project_id)
      
      if !project.nil? and !start_date.nil? and !end_date.nil?
        # make sure the dates are within the range of the project start and end dates
        errors.add(:start_date, "needs to start on or after the start date of the project (#{project.start_date.to_s(:year_month)})") if start_date < project.start_date
        errors.add(:end_date, "needs to end on or before the end date of the project (#{project.end_date.to_s(:year_month)})") if end_date > project.end_date
      
        validate_dates_not_swapped(errors, start_date, end_date)
      end
    end
  end
end