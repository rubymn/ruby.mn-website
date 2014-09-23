RubyMnWebsite::Application.routes.draw do
  resources :users do
    get 'page/:page', :action => :index, :on => :collection

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
      #put    :approve
    end

    collection do
      get :user_index
    end
  end

  resources :openings do
    get 'page/:page', :action => :index, :on => :collection
  end
  resources :projects
  resource :session
  resources :sponsors

  # map.admin '/admin/:action/:id', :controller => 'admin'
  #match '/admin/:action/:id' => 'admin', :as => :admin

  put '/admin/events/:id/approve' => 'admin#approve', :as => :admin_approve_event
  match '/admin'        => 'admin#index',   :as => :admin_index

  root :to => 'welcome#index'
end
