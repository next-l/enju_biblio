Rails.application.routes.draw do
  resources :item_custom_properties
  resources :manifestation_custom_properties
  resources :resource_export_files

  resources :identifier_types

  get "/manifestations/:manifestation_id/items" => redirect("/items?manifestation_id=%{manifestation_id}")

  resources :manifestations

  resources :items

  resources :agents

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
  resources :resource_import_results, only: [:index, :show, :destroy]
  resources :agent_import_files
  resources :agent_import_results, only: [:index, :show, :destroy]

  resources :import_requests

  resources :picture_files

  resources :agents do
    resources :agent_merges
    resources :agent_merge_lists
  end
  resources :agent_merge_lists do
    resources :agents
    resources :agent_merges
  end
  resources :agent_merges

  resources :series_statements do
    resources :series_statement_merges
    resources :series_statement_merge_lists
  end
  resources :series_statement_merge_lists do
    resources :series_statements
    resources :series_statement_merges
  end
  resources :series_statement_merges

  get '/isbn/:isbn_id' => 'manifestations#index'
  get '/page/advanced_search' => 'page#advanced_search'

  get '/openurl' => 'openurl#index'
end
