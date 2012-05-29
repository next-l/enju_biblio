Rails.application.routes.draw do
  resources :works, :controller => 'manifestations' do
    resources :patrons
    resources :creates
  end

  resources :expressions, :controller => 'manifestations' do
    resources :patrons
    resources :realizes
  end

  resources :creates
  resources :create_types
  resources :realizes
  resources :realize_types
end
