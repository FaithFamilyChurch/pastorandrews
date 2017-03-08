Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

	get 'pages/index'
	root 'pages#index'

	get 'about', to: 'about#index', as: :about
	get 'about/index'

	get 'contact', to: 'contact#index', as: :contact
	get 'contact/index'

	get 'resources', to: 'resources#index', as: :resources
	get 'resources/index'

#	get 'pages/oops'
#	get 'oops' => 'pages#oops'

	resources :pages do
		member do
#			get "getForecastSearch"
#			get "getForecastLatLong"
		end
	end


	match "*path", to: redirect('/'), via: :all

end
