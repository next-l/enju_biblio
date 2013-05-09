Rails.application.routes.draw do
  resources :identifier_types

  resources :manifestations do
    resources :patrons
    resources :produces
    resources :exemplifies
    resources :series_statements
    resources :items
    resources :picture_files
    resources :manifestations
    resources :manifestation_relationships
  end

  resources :items do
    resources :patrons
    resources :owns
    resource :exemplify
    resources :manifestations, :only => [:index]
  end

  resources :patrons do
    resources :works, :controller => 'manifestations'
    resources :expressions, :controller => 'manifestations'
    resources :manifestations
    resources :items
    resources :picture_files
    resources :patrons
    resources :patron_relationships
    resources :creates
    resources :realizes
    resources :produces
  end

  resources :works, :controller => 'manifestations', :except => [:index, :new, :create] do
    resources :patrons
    resources :creates
  end

  resources :expressions, :controller => 'manifestations', :except => [:index, :new, :create] do
    resources :patrons
    resources :realizes
  end

  resources :creators, :controller => 'patrons', :except => [:index, :new, :create] do
    resources :manifestations
  end

  resources :contributors, :controller => 'patrons', :except => [:index, :new, :create] do
    resources :manifestations
  end

  resources :publishers, :controller => 'patrons', :except => [:index, :new, :create] do
    resources :manifestations
  end

  resources :creates
  resources :create_types
  resources :realizes
  resources :realize_types
  resources :produces
  resources :produce_types
  resources :owns
  resources :exemplifies

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
  resources :extents
  resources :patron_types

  resources :patron_relationship_types
  resources :patron_relationships
  resources :manifestation_relationship_types
  resources :manifestation_relationships

  resources :resource_import_files do
    resources :resource_import_results
  end
  resources :resource_import_results
  resources :patron_import_files do
    resources :patron_import_results
  end
  resources :patron_import_results

  resources :import_requests

  resources :picture_files

  get '/isbn/:isbn' => 'manifestations#index'
  get '/page/advanced_search' => 'page#advanced_search'
end
