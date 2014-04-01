IxcMall::Application.routes.draw do
  get "vendors/index"
  get "vendors/map"
  get "vendors/vendor_search"
  get "vendors/vendor_catgory"
  get "vendors/research_vendor_goods_by_category"

  get "home/search"
  get "home/card"
  get "home/about_us"
  get "home/research_goods_by_category"
  root "home#index"

  get "customers/set_order_time_list"
  get "customers/shopping_car"
  get "customers/order_page"
  get "customers/success_page"
  post "customers/notify_page"
  get "customers/error_page"
  get "customers/center"
  get "customers/buy"
  get "customers/add_in_shopping_car"
  get "customers/order_confirm"
  get "customers/cart_confirm"
  get "customers/check_inventory"

  get "goods/set_sku_info"

  get 'test' => 'home#test'
  get 'test1' => 'home#test1'
  devise_for :customers,
             :controllers => { :sessions => "devise_hack/sessions", :registrations=> "devise_hack/registrations"}

    resources :vendors
    resources :goods
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
