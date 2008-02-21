require File.dirname(__FILE__) + '/../test_helper'
require 'monthly_details_controller'

# Re-raise errors caught by the controller.
class MonthlyDetailsController; def rescue_action(e) raise e end; end

class MonthlyDetailsControllerTest < Test::Unit::TestCase
  def setup
    @controller = MonthlyDetailsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_truth
    assert true
  end

  # def test_should_get_index
  #   get :index
  #   assert_response :success
  #   assert_not_nil assigns(:monthly_details)
  # end
  # 
  # def test_should_get_new
  #   get :new
  #   assert_response :success
  # end
  # 
  # def test_should_create_monthly_detail
  #   assert_difference('MonthlyDetail.count') do
  #     post :create, :monthly_detail => { }
  #   end
  # 
  #   assert_redirected_to monthly_detail_path(assigns(:monthly_detail))
  # end
  # 
  # def test_should_show_monthly_detail
  #   get :show, :id => 1
  #   assert_response :success
  # end
  # 
  # def test_should_get_edit
  #   get :edit, :id => 1
  #   assert_response :success
  # end
  # 
  # def test_should_update_monthly_detail
  #   put :update, :id => 1, :monthly_detail => { }
  #   assert_redirected_to monthly_detail_path(assigns(:monthly_detail))
  # end
  # 
  # def test_should_destroy_monthly_detail
  #   assert_difference('MonthlyDetail.count', -1) do
  #     delete :destroy, :id => 1
  #   end
  # 
  #   assert_redirected_to monthly_details_path
  # end
end
