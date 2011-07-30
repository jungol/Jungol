Jungola::Application.routes.draw do

  devise_for :users

  resources :updates_requests, :only => [:create]

  resources :comments, :only => [:create, :update] do
    member do
      post :update
    end
  end

  match 'groups/:id/join', :controller => :groups, :action => :join, :via => [:post, :get], :as => "join"

  match 'groups/:id/link', :controller => :groups, :action => :link, :via => [:post, :get], :as => "link"

  resources :users, :only => :show
  resources :groups do
    resources :discussions do
      member do
        post :share
        put :share
        post :update
      end
    end
    resources :todos do
      member do
        post :share
        post :update
        put :share
      end
      resources :tasks do
        member do
          post :update
        end
      end
    end
  end

  resources :filter, :only => :index do
    collection do
      post :filter
      post :select
    end
  end

  match '/invite', :to => 'pages#invite'

  match '/user' => "filter#index", :as => :user_root

  root :to => 'pages#welcome'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
