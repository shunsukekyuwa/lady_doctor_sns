Rails.application.routes.draw do
  devise_for :males, controllers:{
    sessions:        'males/sessions',
    passwords:       'males/passwords',
    registrations:   'males/registrations'
  }
  devise_for :lady_doctors, controllers:{
    sessions:        'lady_doctors/sessions',
    passwords:       'lady_doctors/passwords',
    registrations:   'lady_doctors/registrations'
  }
  devise_for :admins, controllers:{
    sessions:        'admins/sessions',
    passwords:       'admins/passwords',
    registrations:   'admins/registrations'
  }
  
  #devise_scope :male do
   #get "males/sign_in", to: "devise/sessions#new"
  #end

  #root設定
  #root to: 'males/sessions#new'
  devise_scope :male do
      get "/", :to => "males/sessions#new"
  end
 
  #resources :relationships, only: [:destroy]
  
  #post "relationships/:id/:lady_doctor_id", :controller => 'relationships', :action => 'create'
  #くそrouting
  #get "relationships/:id/:lady_doctor_id" => 'relationships#create'
  #resources :lady_doctor_posts

  resources :admins, only: [:index]
  get "admins/confirm/:id" => "admins#confirm"


  get "males/:male_id/lady_doctor_posts/:id/comment" => "male_post_comments#new", as: :new_male_post_comment
  post "males/:male_id/profile_image/:id" => 'males#profile_update', as: :male_image
  get 'males/:male_id/lady_doctor_posts/:id' => 'males#lady_doctor_posts_show', as: :lady_doctor_posts_show
  get 'males/:male_id/lady_doctor/:id' => 'males#lady_doctor_index', as: :lady_doctor_index


  resources :males do
    member do
      get :following
      get :unfollowing, only: [:index]      
    end
    resources :male_posts
  end

  get 'males/:male_id/unfollowing/lady_docotrs/:id' => 'males#unfollowing_index', as: :unfollowing_index

  resources :male_post_comments, except: [:new]
  
  #resources :lady_doctor_post_comments

   #get "males/:id/unfollowing/:lady_doctor_id", :controller => 'males', :action => 'unfollow_show'
 
  

  resources :lady_doctors do
    resources :lady_doctor_posts
  end
  

 
  get 'lady_doctors/:lady_doctor_id/follow_male/:id' => 'lady_doctors#follow_show', as: :follower
  post "lady_doctors/:lady_doctor_id/profile_image/:id" => 'lady_doctors#profile_update', as: :lady_doctor_image
  

  resources :relationships, path: "lady_doctors/:id/follow", only: [:create]
  resources :relationships, path: "lady_doctors/:lady_doctor_id/unfollow", only: [:destroy]

  resources :likes, path: "males/:id/like", only: [:create]
  resources :likes, path: "males/:male_id/unlike", only: [:destroy]

  #resources :lady_doctors, path: "lady_doctors/:lady_doctor_id/follow_male", controller: :lady_doctor, action: :follow_show, as: :follower
  
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
