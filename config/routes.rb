ActionController::Routing::Routes.draw do |map|
  # Add your own custom routes here.
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Here's a sample route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  map.resource :archive, :member=>{:search=>:any}
  map.resources :pevents, :member=>{:approve=>:put}, :collection=>{:rss=>:get}
  map.resources :users, :member=>{:login=>:get}, :new=>{:validate=>:get, :forgot_password=>:get, :reset=>:post, :change_password=>:get, :set_password=>:post} do |users|
    users.resources :events
  end
  map.resources :projects
  map.resource :session
  map.connect '', :controller => "welcome", :action=>'index'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
