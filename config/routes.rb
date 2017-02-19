Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

	get 'pages/index'
	root 'pages#index'

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
