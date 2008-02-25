require File.dirname(__FILE__) + '/../test_helper'

class TaskTest < ActiveSupport::TestCase
  load_all_fixtures
  
  should_belong_to :project
  should_have_many :monthly_details
  should_require_attributes :name, :start_date, :end_date, :budget
  should_only_allow_numeric_values_for  :budget
  
  context "A task instance" do
  
    setup do
      @project = Project.find_by_name("project_one")
    end
  
    should "be valid" do
      task = Task.new(:name => "My Project",
                      :start_date => "01/01/2008",
                      :end_date => "02/01/2008",
                      :budget => 100000,
                      :project => @project )
                          
      assert task.valid?
    end
  
    context "that is one month long" do
      should "should have one monthly detail" do
        task = Task.new(:name => "My Project",
                        :start_date => "01/01/2008",
                        :end_date => "01/01/2008",
                        :budget => 100000,
                        :project => @project )
                              
        assert task.valid?
        assert task.save
        
        assert_equal task.monthly_details.size, 1
      end
    end
    
    context "that is two months long" do
      should "should have two monthly details" do
        task = Task.new(:name => "My Project",
                        :start_date => "01/01/2008",
                        :end_date => "02/01/2008",
                        :budget => 100000,
                        :project => @project )
                              
        assert task.valid?
        assert task.save
        
        assert_equal task.monthly_details.size, 2
      end
    end
    
    should "fail with dates swapped" do
      task = Task.new(:name => "My Project",
                      :start_date => "03/01/2008",
                      :end_date => "01/01/2008",
                      :budget => 10000,
                      :project => @project )
                            
      assert !task.valid?
      assert_equal "The start date can't be after the end date", task.errors.on(:base)
      assert_equal "is invalid", task.errors.on(:start_date)
      assert_equal "is invalid", task.errors.on(:end_date)
    end
    
    should "fail with dates outside the range of the project" do
      task = Task.new(:name => "My Project",
                      :start_date => "03/01/2007",
                      :end_date => "01/01/2009",
                      :budget => 10000,
                      :project => @project )
                            
      assert !task.valid?
      assert_equal "needs to start on or after the start date of the project (01/2008)", task.errors.on(:start_date)
      assert_equal "needs to end on or before the end date of the project (03/2008)", task.errors.on(:end_date)
    end
    
    should "have a green status" do
      task_one = tasks(:complete_project_task_one)  
          
      assert_equal task_one.status("2007-12-01"), "Green - 1.0"
      assert_equal task_one.status("2008-01-01"), "Green - 1.0"
    end
    
    should "have a black status" do
      task_two = tasks(:complete_project_task_two)
      assert_equal task_two.status("2007-12-01"), "Black - 0.58"
    end
    
    should "have a yellow status" do
      task_two = tasks(:complete_project_task_two)
      assert_equal task_two.status("2008-01-01"), "Yellow - 0.9"
    end
    
    should "not be ready to be completed" do
      tmp_project = Project.new(:name => "My Project",
                                :start_date => "01/01/2008",
                                :end_date => "08/01/2008",
                                :total_budget => 10000)
      assert tmp_project.save                      
      
      task = Task.new(:name => "My Task",
                      :start_date => "01/01/2008",
                      :end_date => "02/01/2008",
                      :budget => 10000,
                      :project => tmp_project )
      assert task.save
      assert_equal task.monthly_details.size, 2
      
      # don't allow a task to be completed when the planned_complete_in_dollars is 0 or nil
      assert_equal task.completed, false
      
      monthly_details = task.monthly_details.find(:all)
      
      monthly_details[0].date = "01/01/2008"
      monthly_details[0].planned_complete_in_dollars = 5000
      monthly_details[0].actual_completed_in_dollars = 5000
      monthly_details[0].actual_spent_in_dollars = 5000
      assert monthly_details[0].save
      
      monthly_details[1].date = "02/01/2008"
      monthly_details[1].planned_complete_in_dollars = 10000
      monthly_details[1].actual_completed_in_dollars = 9000
      monthly_details[1].actual_spent_in_dollars = 10000
      assert monthly_details[1].save
      
      assert_equal task.completed, false
    end
    
    should "be completed" do
      tmp_project = Project.new(:name => "My Project",
                                :start_date => "01/01/2008",
                                :end_date => "08/01/2008",
                                :total_budget => 10000)
      assert tmp_project.save                      
      
      task = Task.new(:name => "My Task",
                      :start_date => "01/01/2008",
                      :end_date => "02/01/2008",
                      :budget => 10000,
                      :project => tmp_project )
      assert task.save
      assert_equal task.monthly_details.size, 2
      
      monthly_details = task.monthly_details.find(:all)
      
      monthly_details[0].date = "01/01/2008"
      monthly_details[0].planned_complete_in_dollars = 5000
      monthly_details[0].actual_completed_in_dollars = 5000
      monthly_details[0].actual_spent_in_dollars = 5000
      assert monthly_details[0].save
      
      monthly_details[1].date = "02/01/2008"
      monthly_details[1].planned_complete_in_dollars = 10000
      monthly_details[1].actual_completed_in_dollars = 10000
      monthly_details[1].actual_spent_in_dollars = 10000
      assert monthly_details[1].save
      
      assert_equal task.ready_to_be_completed?, true
      
      task.complete_task
      assert_equal task.monthly_details.size, 8
      assert_equal task.completed, true
      
      md = task.monthly_details.find(:first, :order => "date DESC")
      assert_equal md.date.to_s, "2008-08-01"
      assert_equal md.planned_complete_in_dollars, 10000
      assert_equal md.actual_completed_in_dollars, 10000
      assert_equal md.actual_spent_in_dollars, 10000
    end
    
    should "have the task end date extended by one month" do
      task_two = tasks(:task_two)
      assert_equal task_two.monthly_details.size, 1
      
      task_two.extend_end_date
      assert_equal task_two.monthly_details.size, 2
      
      md = task_two.monthly_details.find(:first, :order => "date DESC")
      assert_equal md.date.to_s, "2008-02-01"
      
      assert_equal task_two.end_date.to_s, "2008-02-01"
      
      assert_equal task_two.project.end_date.to_s, "2008-03-01"
    end
    
    should "have the task end date extended by three months" do
      task_two = tasks(:task_two)
      assert_equal task_two.monthly_details.size, 1
      
      task_two.extend_end_date
      task_two.extend_end_date
      task_two.extend_end_date
      assert_equal task_two.monthly_details.size, 4
      
      md = task_two.monthly_details.find(:first, :order => "date DESC")
      assert_equal md.date.to_s, "2008-04-01"
      
      assert_equal task_two.end_date.to_s, "2008-04-01"
      
      assert_equal task_two.project.end_date.to_s, "2008-04-01"
    end
  end
end