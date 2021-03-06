IxcMall::Application.routes.draw do

  namespace :center do
    get 'order' => 'customer#order'
    get 'account_info' => 'customer#account_info'
    post 'update_cus_pwd' => 'customer#update_cus_pwd'
    get 'car_wash' => 'customer#car_wash'
    get 'consumption' => 'customer#consumption'
    get 'cash_account' => 'customer#cash_account'
    get 'add_withdraw_cash' => 'customer#add_withdraw_cash'
    get 'update_pwd' => 'customer#update_pwd'
    get 'contact_us'=>'customer#contact_us'
    get 'update_order_time'=>'customer#update_order_time'
    get 'to_alipay'=>'customer#to_alipay'
  end

  namespace :topic do
    get 'shangxian' => 'topic#shangxian'
    get 'tcx' => 'topic#tcx'
    get 'june_act' => 'topic#june_act'
  end

  get "vendors/index"
  get "vendors/map"
  get "vendors/vendor_search"
  get "vendors/vendor_catgory"
  get "vendors/research_vendor_goods_by_category"

  get "home/search"
  get "home/card"
  get "home/card_168"
  get "home/about_us"
  get "home/research_goods_by_category"
  root "home#index"

  get "customers/set_order_time_list"
  get "customers/shopping_car"
  post "customers/order_page"
  get "customers/success_page"
  post "customers/notify_page"
  get "customers/error_page"
  get "customers/center"
  post "customers/buy"
  get "customers/buy_now"
  get "customers/add_in_shopping_car"
  get "customers/order_confirm"
  get "customers/cart_confirm"
  get "customers/check_inventory"
  get "customers/del_shopping_car"
  get "customers/allcarbrand"
  get "customers/carbrand"
  get 'customers/carset/:id'   => 'customers#carset'
  get "goods/set_sku_info"

  get "customers/check_is_have_plate_number"

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
