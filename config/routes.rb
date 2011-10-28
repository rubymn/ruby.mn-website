ActionController::Routing::Routes.draw do |map|
  # Add your own custom routes here.
  # The priority is based upon order of creation: first created -> highest priority.

  # Here's a sample route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # You can have the root of your site routed by hooking up ''
  # -- just remember to delete public/index.html.
  map.resources :openings
  map.resources :users, :member => { :login => :get },
                        :new    => { :validate        => :get,
                                     :forgot_password => :get,
                                     :reset           => :post,
                                     :change_password => :get,
                                     :set_password    => :post },
                                     :except => [:edit, :update]
  map.resource :for_hire
  map.resources :events, :member     => { :admdestroy => :delete, :approve => :put },
                         :collection => { :user_index => :get }
  map.resources :projects
  map.resource :session
  map.root  :controller => "welcome", :action => 'index'
  map.admin '/admin/:action/:id', :controller => 'admin'
  map.admindex '/admin', :controller => 'admin', :action => 'index'

  map.for_hires '/for_hires', :controller => 'for_hires', :action => 'index'

  map.sponsors '/sponsors', :controller => 'static', :action => 'sponsors'
  map.special_offers '/special-offers', :controller => 'static', :action => 'special_offers'
end
