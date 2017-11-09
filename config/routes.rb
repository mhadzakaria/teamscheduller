Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :resumes, only: [:destroy, :create]
  resources :positions, except: [:show]
  resources :schedules, except: [:edit, :update]
  resources :personnels do
  	member do
  		get 'choose_position'
      get 'choose_schedule', to: 'schedules#choose_schedule'
      get 'position_schedule', to: 'schedules#position_schedule'
      post 'choose_position_sch', to: 'schedules#choose_position_sch'
  	end
  	collection do
  		post 'add_position'
  	end
  end

  root 'personnels#index'
end
