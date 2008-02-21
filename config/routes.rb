ActionController::Routing::Routes.draw do |map|
  # map.resources :projects, :has_many => :tasks
  
  map.resources :tasks, :collection => { :completed => :get }, :member => { :complete => :put }
  
  map.resources :projects do |project|
    project.resources :tasks, :member => { :extend_end_date => :put } do |task|
      task.resources :monthly_details
    end
  end
  
  # example of nested resources
  #map.resources :dinners do |dinner|
  #  dinner.resources :dishes do |dish|
  #    dish.resources :side_courses
  #  end
  #  dinner.resources :drinks
  #end

  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  map.connect '', :controller => "projects"

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  # map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
