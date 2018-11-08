Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

  # Override default Devise registrations controller
  devise_for :users, :controllers => {:registrations => 'registrations'}

  resources :agreements

  scope :module => 'judging' do
    get '/judging/entries' => 'entries#index', :as => :judging_entries
    get '/judging/entries/toggle_hidden' => 'entries#toggle_hidden_entries', :as => :toggle_hidden_entries
    get '/judging/entries/:category_id' => 'entries#index'
    get '/judging/entry/:hash' => 'entries#show', :as => :judging_entry
    put '/judging/entry/:hash/place' => 'entries#place', :as => :placing_entry
    put '/judging/entry/:hash/clear_place' => 'entries#clear_place', :as => :clear_place_entry
  end

  get 'states/select/:country_id' => 'states#get_select_for_country'

  # Entry Routes
  get  'entries/new' => 'entries#new', :as => :new_entry
  get  'entries' => 'entries#index',  :as => :entries
  post 'entries' => 'entries#create', :as => :create_entry

  get    'entries/:hash/confirmation' => 'entries#confirmation', :as => :entry_confirmation
  get    'entries/:hash' => 'entries#edit',    :as => :edit_entry
  put    'entries/:hash' => 'entries#update',  :as => :update_entry
  delete 'entries/:hash' => 'entries#destroy', :as => :delete_entry

  # Image Routes
  get  'images/upload' => 'images#for_entry', :as => :images_list
  post 'images/upload' => 'images#upload',    :as => :upload_image
  get  'images/download/:hash' => 'images#download',   :as => :download_image
  get  'images/thumbnail/:hash' => 'images#thumbnail', :as => :image_thumbnail
  delete 'images/:hash' => 'images#destroy', :as => :delete_image

  # Contact Routes
  post 'contact/report_a_problem' => 'contact#report_a_problem'

  get 'export/website/:year' => 'export#website'
  get 'export/website' => 'export#website'
  get 'export/tsv/:year' => 'export#tsv'
  get 'export/tsv' => 'export#tsv'
  get 'export/images' => 'export#images'
  get 'export' => 'export#index', :as => :export

  # Statistics
  get 'statistics/:year' => 'statistics#index'
  get 'statistics' => 'statistics#index', :as => :statistics

  # Users
  get 'users/manage' => 'users#manage', :as => :manage_users
  post 'users/add' => 'users#add_child'
  get 'users/impersonate/:id' => 'users#impersonate'
  get 'users/unimpersonate' => 'users#unimpersonate', :as => :unimpersonate

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
