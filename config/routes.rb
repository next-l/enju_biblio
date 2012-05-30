Rails.application.routes.draw do
  resources :works, :controller => 'manifestations' do
    resources :patrons
    resources :creates
  end

  resources :expressions, :controller => 'manifestations' do
    resources :patrons
    resources :realizes
  end

  resources :manifestations do
    resources :patrons
    resources :produces
    resources :series_statements
    resources :series_has_manifestations
  end

  resources :creates
  resources :create_types
  resources :realizes
  resources :realize_types
  resources :produces
  resources :produce_types

  resources :countries
  resources :languages

  resources :series_has_manifestations

  resources :series_statements do
    resources :manifestations
    resources :series_has_manifestations
  end
end
