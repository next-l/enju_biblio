require 'active_record/fixtures'
namespace :enju_biblio do
  desc "create initial records for enju_biblio"
  task :setup => :environment do
    Dir.glob(Rails.root.to_s + '/db/fixtures/enju_biblio/*.yml').each do |file|
      ActiveRecord::Fixtures.create_fixtures('db/fixtures/enju_biblio', File.basename(file, '.*'))
    end
  end

  desc "import manifestations and items from a TSV file"
  task :resource_import => :environment do
    ResourceImportFile.import
  end

  desc "import manifestations and items from a TSV file"
  task :agent_import => :environment do
    AgentImportFile.import
  end
end
