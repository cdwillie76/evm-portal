require File.dirname(__FILE__) + '/../test_helper'

class ProjectTest < ActiveSupport::TestCase
  
  fixtures :projects
  fixtures :tasks
  fixtures :monthly_details
  
  # Replace this with your real tests.
  def test_creating_a_valid_project
    project = Project.new(:name => "My Project",
                          :start_date => "12/01/2007",
                          :end_date => "12/01/2008",
                          :total_budget => 100000 )
                          
    assert project.valid?
  end
  
  def test_creating_empty_project
    project = Project.new
    
    assert !project.valid?
    
    assert project.errors.invalid?(:name)
    assert_equal "can't be blank", project.errors.on(:name)
    
    assert project.errors.invalid?(:start_date)
    assert_equal "can't be blank", project.errors.on(:start_date)
    
    assert project.errors.invalid?(:end_date)
    assert_equal "can't be blank", project.errors.on(:end_date)
    
    assert project.errors.invalid?(:total_budget)
    assert_equal ["can't be blank", "is not a number"], project.errors.on(:total_budget)
  end
  
  def test_create_project_with_dates_swapped
    project = Project.new(:name => "My Project",
                          :start_date => "12/01/2008",
                          :end_date => "12/01/2007",
                          :total_budget => 100000 )
                          
    assert !project.valid?
    assert_equal "The start date can't be after the end date", project.errors.on(:base)
    assert_equal "is invalid", project.errors.on(:start_date)
    assert_equal "is invalid", project.errors.on(:end_date)
  end
  
  def test_creating_project_with_no_total_budget
    project = Project.new(:name => "My Project",
                          :start_date => "12/01/2007",
                          :end_date => "12/01/2008" )
    
    assert !project.valid?
    assert_equal ["can't be blank", "is not a number"], project.errors.on(:total_budget)
  end
  
  def test_creating_project_with_invalid_total_budget
    project = Project.new(:name => "My Project",
                          :start_date => "12/01/2007",
                          :end_date => "12/01/2008",
                          :total_budget => "junk" )
    
    assert !project.valid?
    assert_equal "is not a number", project.errors.on(:total_budget)
  end
  
  def test_creating_project_with_small_total_budget
    project = Project.new(:name => "My Project",
                          :start_date => "12/01/2007",
                          :end_date => "12/01/2008",
                          :total_budget => 0.5 )
    
    assert !project.valid?
    assert_equal "must be greater than or equal to 1", project.errors.on(:total_budget)
  end
  
  def test_allocated_budget
    project = Project.new(:name => "My Project",
                          :start_date => "12/01/2007",
                          :end_date => "12/01/2008",
                          :total_budget => 100000 )
                          
    assert project.valid?
    project.save
    
    task = project.tasks.new(:name => "Task One",
                             :start_date => "12/01/2007",
                             :end_date => "12/01/2008",
                             :budget => 10000 )
    
    task.save
                      
    task = project.tasks.new(:name => "Task Two",
                             :start_date => "12/01/2007",
                             :end_date => "12/01/2008",
                             :budget => 10000 )
                             
    task.save
                      
    assert_equal 20000, project.allocated_budget                       
  end
  
  def test_find_most_recent
    project = Project.new(:name => "My Project 1",
                          :start_date => "12/01/2007",
                          :end_date => "12/01/2008",
                          :total_budget => 100000 )
    project.save
    
    project = Project.new(:name => "My Project 2",
                          :start_date => "12/01/2007",
                          :end_date => "12/01/2008",
                          :total_budget => 100000 )
    project.save
    
    project = Project.new(:name => "My Project 3",
                          :start_date => "12/01/2007",
                          :end_date => "12/01/2008",
                          :total_budget => 100000 )
    project.save
    
    project = Project.new(:name => "My Project 4",
                          :start_date => "12/01/2007",
                          :end_date => "12/01/2008",
                          :total_budget => 100000 )
    project.save
    
    project = Project.new(:name => "My Project 5",
                          :start_date => "12/01/2007",
                          :end_date => "12/01/2008",
                          :total_budget => 100000 )
    project.save
    
    project = Project.new(:name => "My Project 6",
                          :start_date => "12/01/2007",
                          :end_date => "12/01/2008",
                          :total_budget => 100000 )
    project.save
    
    project = Project.new(:name => "My Project 7",
                          :start_date => "12/01/2007",
                          :end_date => "12/01/2008",
                          :total_budget => 100000 )
    project.save
    
    project = Project.new(:name => "My Project 8",
                          :start_date => "12/01/2007",
                          :end_date => "12/01/2008",
                          :total_budget => 100000 )
    project.save
    
    project = Project.new(:name => "My Project 9",
                          :start_date => "12/01/2007",
                          :end_date => "12/01/2008",
                          :total_budget => 100000 )
    project.save
    
    project = Project.new(:name => "My Project 10",
                          :start_date => "12/01/2007",
                          :end_date => "12/01/2008",
                          :total_budget => 100000 )
    project.save
    
    project = Project.new(:name => "My Project 11",
                          :start_date => "12/01/2007",
                          :end_date => "12/01/2008",
                          :total_budget => 100000 )
    project.save
    
    project = Project.new(:name => "My Project 12",
                          :start_date => "12/01/2007",
                          :end_date => "12/01/2008",
                          :total_budget => 100000 )
    project.save
    
    projects = Project.find_most_recent
    
    assert_equal 10, projects.size
  end
  
  def test_project_status
    project = projects(:complete_project)  
    
    assert_equal project.status("2007-12-01"), "Yellow - 0.87"
    assert_equal project.status("2008-01-01"), "Yellow - 0.95"
  end
end