module EnjuBiblio
  module Generators
    class ViewsGenerator < Rails::Generators::Base
      source_root File.expand_path('../../../../app/views', __FILE__)

      def copy_files
        directories = %w(
          accepts
          carrier_types
          content_types
          countries
          create_types
          creates
          donates
          exemplifies
          extents
          form_of_works
          frequencies
          import_requests
          items
          languages
          licenses
          manifestation_relationship_types
          manifestation_relationships
          manifestations
          medium_of_performances
          owns
          patron_import_files
          patron_import_results
          patron_relationship_types
          patron_relationships
          patron_types
          patrons
          picture_files
          produce_types
          produces
          realize_types
          realizes
          resource_import_files
          resource_import_results
          series_has_manifestations
          series_statement_relationships
          series_statements
        )

        directories.each do |dir|
          directory dir, "app/views/#{dir}"
        end
      end
    end
  end
end
