Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

  # Override default Devise registrations controller
  devise_for :users, :controllers => {:registrations => 'registrations'}

  resources :agreements

  get 'states/select/:country_id' => 'states#get_select_for_country'
  get 'entries/new' => 'entries#new', :as => :new_entry
  post 'entries' => 'entries#create'
  get 'entries' => 'entries#index'
  get 'entries/:hash' => 'entries#show'
  delete 'entries/:hash' => 'entries#destroy'
  put 'entries/:hash' => 'entries#update'
  get 'entries/:hash/confirmation' => 'entries#confirmation'
  post 'images/upload' => 'images#upload'
  get 'images/upload' => 'images#for_entry'
  get 'images/download/:hash' => 'images#download'
  get 'images/thumbnail/:hash' => 'images#thumbnail'
  delete 'images/:hash' => 'images#destroy'
  post 'contact/report_a_problem' => 'contact#report_a_problem'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
