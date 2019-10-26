Rails.application.routes.draw do
	mount Ckeditor::Engine => '/ckeditor'
	ActiveAdmin.routes(self)
	# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions'  }
	root 'home#index'

	get  'account_created' => "home#account_created"

	resources :categories
	resources :products do
		member do
			get 'category_product'
		end
		collection do
			get 'search_product'
		end
	end

	resources :cart_items, only: [:show, :update, :destroy] do
		collection do
			get :add_to_cart
			post :checkout
			get :cart_details
			get :checkout_without_login
			get :proceed_checkout
			get :choose_billing_address
			get :choose_shipping_address
			get :order_confirmation
			get :guest_billing_details
			get :guest_shipping_address
			get :guest_confirm_order
			get :bulk_info
		end
	end

	resources :users do
		collection do
			get :user_account
			get :address_book
			get :orders_completed
			get :order_status
			get :recent_visit_items
			get :user_account
			patch :update_password
		end
		member do
			get :order_details
		end
	end

	resources :addresses do
		collection do
			get :list_states
		end
	end

	resources :orders do
		collection do
			post :cancel_url
			post :redirect_url
			get :order_cancel
		end
		member do
			get :invoice
			get :guest_order_invoice
			get :guest_order_completed
		end
	end

	resources :contacts, only: [:new, :create]

	get '/change/country' => "addresses#change_country_text"
	get '/privacy-policy' => "home#privacy_policy", as: :privacy_policy
	get '/shipping-policy' => "home#shipping_policy", as: :shipping_policy
	get '/terms-conditions' => "home#terms_conditions", as: :terms_conditions
	get '/about_us' => "home#about_us", as: :about_us

	get "/404"  => "errors#not_found"
	get "/500"  => "errors#internal_server_error"





end
