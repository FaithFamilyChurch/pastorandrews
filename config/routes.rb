Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

    get 'pages/splash'
    root 'pages#splash'

#	get 'pages/index'
#	root 'pages#index'

#	get 'about', to: 'about#index', as: :about
#	get 'about/index'

#	get 'messages', to: 'messages#index', as: :messages
#	get 'messages/index'

#	get 'picks', to: 'picks#index', as: :picks
#	get 'picks/index'

#	get 'pages/oops'
#	get 'oops' => 'pages#oops'

	resources :pages do
		member do
            post "requestNewSubscription"
		end
	end


	match "*path", to: redirect('/'), via: :all

end
