require 'active_record/fixtures'
require 'tasks/agent_type'
require 'tasks/carrier_type'
require 'tasks/content_type'
require 'tasks/identifier_type'
require 'tasks/item'

namespace :enju_biblio do
  desc "create initial records for enju_biblio"
  task setup: :environment do
    Dir.glob(Rails.root.to_s + '/db/fixtures/enju_biblio/*.yml').each do |file|
      ActiveRecord::FixtureSet.create_fixtures('db/fixtures/enju_biblio', File.basename(file, '.*'))
    end
    update_carrier_type
  end

  desc "import manifestations and items from a TSV file"
  task resource_import: :environment do
    ResourceImportFile.import
  end

  desc "import manifestations and items from a TSV file"
  task agent_import: :environment do
    AgentImportFile.import
  end

  desc "upgrade enju_biblio to 1.3"
  task upgrade_to_13: :environment do
    Rake::Task['statesman:backfill_most_recent'].invoke('AgentImportFile')
    Rake::Task['statesman:backfill_most_recent'].invoke('ImportRequest')
    Rake::Task['statesman:backfill_most_recent'].invoke('ResourceExportFile')
    Rake::Task['statesman:backfill_most_recent'].invoke('ResourceImportFile')
    update_carrier_type
    puts 'enju_biblio: The upgrade completed successfully.'
  end

  desc "upgrade enju_biblio to 2.0"
  task upgrade: :environment do
    class_names = [
      AgentRelationshipType, AgentType, CarrierType, ContentType,
      CreateType, FormOfWork, Frequency, Language, License,
      ManifestationRelationshipType, MediumOfPerformance, ProduceType,
      RealizeType
    ]
    class_names.each do |klass|
      klass.find_each do |record|
        I18n.available_locales.each do |locale|
          next unless record.respond_to?("display_name_#{locale}")
          record.update("display_name_#{locale}": YAML.safe_load(record[:display_name])[locale.to_s])
        end
      end
    end
    puts 'enju_biblio: The upgrade completed successfully.'
  end
end
