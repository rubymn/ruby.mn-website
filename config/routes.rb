# == Route Map
#
#                          GET    /users/page/:page(.:format)          users#index
#               login_user GET    /users/:id/login(.:format)           users#login
#        validate_new_user GET    /users/new/validate(.:format)        users#validate
# forgot_password_new_user GET    /users/new/forgot_password(.:format) users#forgot_password
#           reset_new_user POST   /users/new/reset(.:format)           users#reset
# change_password_new_user GET    /users/new/change_password(.:format) users#change_password
#    set_password_new_user POST   /users/new/set_password(.:format)    users#set_password
#                    users GET    /users(.:format)                     users#index
#                          POST   /users(.:format)                     users#create
#                 new_user GET    /users/new(.:format)                 users#new
#                edit_user GET    /users/:id/edit(.:format)            users#edit
#                     user GET    /users/:id(.:format)                 users#show
#                          PUT    /users/:id(.:format)                 users#update
#                          DELETE /users/:id(.:format)                 users#destroy
#                 for_hire POST   /for_hire(.:format)                  for_hires#create
#             new_for_hire GET    /for_hire/new(.:format)              for_hires#new
#            edit_for_hire GET    /for_hire/edit(.:format)             for_hires#edit
#                          GET    /for_hire(.:format)                  for_hires#show
#                          PUT    /for_hire(.:format)                  for_hires#update
#                          DELETE /for_hire(.:format)                  for_hires#destroy
#                for_hires        /for_hires(.:format)                 for_hires#index
#         admdestroy_event DELETE /events/:id/admdestroy(.:format)     events#admdestroy
#        user_index_events GET    /events/user_index(.:format)         events#user_index
#                   events GET    /events(.:format)                    events#index
#                          POST   /events(.:format)                    events#create
#                new_event GET    /events/new(.:format)                events#new
#               edit_event GET    /events/:id/edit(.:format)           events#edit
#                    event GET    /events/:id(.:format)                events#show
#                          PUT    /events/:id(.:format)                events#update
#                          DELETE /events/:id(.:format)                events#destroy
#                          GET    /openings/page/:page(.:format)       openings#index
#                 openings GET    /openings(.:format)                  openings#index
#                          POST   /openings(.:format)                  openings#create
#              new_opening GET    /openings/new(.:format)              openings#new
#             edit_opening GET    /openings/:id/edit(.:format)         openings#edit
#                  opening GET    /openings/:id(.:format)              openings#show
#                          PUT    /openings/:id(.:format)              openings#update
#                          DELETE /openings/:id(.:format)              openings#destroy
#                 projects GET    /projects(.:format)                  projects#index
#                          POST   /projects(.:format)                  projects#create
#              new_project GET    /projects/new(.:format)              projects#new
#             edit_project GET    /projects/:id/edit(.:format)         projects#edit
#                  project GET    /projects/:id(.:format)              projects#show
#                          PUT    /projects/:id(.:format)              projects#update
#                          DELETE /projects/:id(.:format)              projects#destroy
#                  session POST   /session(.:format)                   sessions#create
#              new_session GET    /session/new(.:format)               sessions#new
#             edit_session GET    /session/edit(.:format)              sessions#edit
#                          GET    /session(.:format)                   sessions#show
#                          PUT    /session(.:format)                   sessions#update
#                          DELETE /session(.:format)                   sessions#destroy
#                 sponsors GET    /sponsors(.:format)                  sponsors#index
#                          POST   /sponsors(.:format)                  sponsors#create
#              new_sponsor GET    /sponsors/new(.:format)              sponsors#new
#             edit_sponsor GET    /sponsors/:id/edit(.:format)         sponsors#edit
#                  sponsor GET    /sponsors/:id(.:format)              sponsors#show
#                          PUT    /sponsors/:id(.:format)              sponsors#update
#                          DELETE /sponsors/:id(.:format)              sponsors#destroy
#      admin_approve_event PUT    /admin/events/:id/approve(.:format)  admin#approve
#              admin_index        /admin(.:format)                     admin#index
#                     root        /                                    welcome#index
#

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
