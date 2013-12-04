Spree::Core::Engine.routes.draw do
  resources :wishlists do
  	member do
    	get :add_all_products_to_cart
    end 
  end
  resources :wished_products, only: [:create, :update, :destroy]
  get '/wishlist' => "wishlists#default", as: "default_wishlist"
end
