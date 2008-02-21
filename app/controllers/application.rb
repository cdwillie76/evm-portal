# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  before_filter :find_recent_projects
  
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_evm_portal_session_id'
  
  protected
    def find_recent_projects
      @recent_projects = Project.find_most_recent  
    end
end