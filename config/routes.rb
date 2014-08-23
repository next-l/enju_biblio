Rails.application.routes.draw do
  resources :resource_export_files

  resources :identifier_types

  get "/manifestations/:manifestation_id/items" => redirect("/items?manifestation_id=%{manifestation_id}")

  resources :manifestations do
    resources :agents
    resources :produces
    resources :series_statements
    resources :items
    resources :picture_files
    resources :manifestations
    resources :manifestation_relationships
  end

  resources :items do
    resources :agents
    resources :owns
    resources :manifestations, :only => [:index]
  end

  resources :agents do
    resources :works, :controller => 'manifestations'
    resources :expressions, :controller => 'manifestations'
    resources :manifestations
    resources :items
    resources :agents
    resources :agent_relationships
  end

  resources :works, :controller => 'manifestations', :except => [:index, :new, :create] do
    resources :agents
    resources :creates
  end

  resources :expressions, :controller => 'manifestations', :except => [:index, :new, :create] do
    resources :agents
    resources :realizes
  end

  resources :creators, :controller => 'agents', :except => [:index, :new, :create] do
    resources :manifestations
  end

  resources :contributors, :controller => 'agents', :except => [:index, :new, :create] do
    resources :manifestations
  end

  resources :publishers, :controller => 'agents', :except => [:index, :new, :create] do
    resources :manifestations
  end

  resources :creates
  resources :create_types
  resources :realizes
  resources :realize_types
  resources :produces
  resources :produce_types
  resources :owns

  resources :donates

  resources :series_statements

  resources :countries
  resources :languages
  resources :form_of_works
  resources :frequencies
  resources :licenses
  resources :medium_of_performances
  resources :carrier_types
  resources :content_types
  resources :agent_types

  resources :agent_relationship_types
  resources :agent_relationships
  resources :manifestation_relationship_types
  resources :manifestation_relationships

  resources :resource_import_files
  resources :resource_import_results, :only => [:index, :show, :destroy]
  resources :agent_import_files
  resources :agent_import_results, :only => [:index, :show, :destroy]

  resources :import_requests

  resources :picture_files

  get '/isbn/:isbn_id' => 'manifestations#index'
  get '/page/advanced_search' => 'page#advanced_search'
end
