RubyMnWebsite::Application.routes.draw do
  resources :users do
    member do
      get :login
    end

    new do
      get  :validate
      get  :forgot_password
      post :reset
      get  :change_password
      post :set_password
    end
  end

  resource :for_hire
  match '/for_hires' => 'for_hires#index', :as => :for_hires

  resources :events do
    member do
      delete :admdestroy
      put    :approve
    end

    collection do
      get :user_index
    end
  end

  resources :openings
  resources :projects
  resource :session

  # map.admin '/admin/:action/:id', :controller => 'admin'
  #match '/admin/:action/:id' => 'admin', :as => :admin

  match 'admin/approve' => 'admin#approve', :as => :admin_approve
  match '/admin'        => 'admin#index',   :as => :admin_index

  match '/sponsors'       => 'static#sponsors',       :as => :sponsors
  match '/special-offers' => 'static#special_offers', :as => :special_offers

  root :to => 'welcome#index'
end
