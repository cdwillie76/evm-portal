require File.dirname(__FILE__) + '/../test_helper'
require 'projects_controller'

# Re-raise errors caught by the controller.
class ProjectsController; def rescue_action(e) raise e end; end

class ProjectsControllerTest < Test::Unit::TestCase
  
  def test_truth
    assert true
  end
  
  # def setup
#     @controller = ProjectsController.new
#     @request    = ActionController::TestRequest.new
#     @response   = ActionController::TestResponse.new
#   end
# 
#   def test_should_get_index
#     get :index
#     assert_response :success
#     assert_not_nil assigns(:projects)
#   end
# 
#   def test_should_get_new
#     get :new
#     assert_response :success
#   end
# 
#   def test_should_create_project
#     assert_difference('Project.count') do
#       post :create, :project => { }
#     end
# 
#     assert_redirected_to project_path(assigns(:project))
#   end
# 
#   def test_should_show_project
#     get :show, :id => 1
#     assert_response :success
#   end
# 
#   def test_should_get_edit
#     get :edit, :id => 1
#     assert_response :success
#   end
# 
#   def test_should_update_project
#     put :update, :id => 1, :project => { }
#     assert_redirected_to project_path(assigns(:project))
#   end
# 
#   def test_should_destroy_project
#     assert_difference('Project.count', -1) do
#       delete :destroy, :id => 1
#     end
# 
#     assert_redirected_to projects_path
#   end
end
