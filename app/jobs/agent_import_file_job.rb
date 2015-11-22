class AgentImportFileJob < ActiveJob::Base
  queue_as :default

  def perform(agent_import_file)
    agent_import_file.import_start
  end
end
