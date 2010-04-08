Fortysquires::Application.routes.draw do |map|
  get "venues/search"

  get "homepage/index"

  get "history/index"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  match '/users/oauth/authorize' => "users#oauth_authorize", :as => :oauth_authorize
  match '/users/oauth/callback' => "users#oauth_callback", :as => :oauth_callback

  match '/history' => "history#index", :as => :history

  match '/checkin' => "checkin#index", :as => :checkin
  match '/checkin/nearby_venues' => "checkin#nearby_venues", :as => :nearby_venues
  match '/checkin/perform' => 'checkin#perform', :as => :perform_checkin

  match '/venues/search' => "venues#search", :as => :venue_search
  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get :short
  #       post :toggle
  #     end
  #
  #     collection do
  #       get :sold
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get :recent, :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  root :to => "homepage#index"

  # See how all your routes lay out with "rake routes"
end
