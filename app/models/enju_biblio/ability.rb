module EnjuBiblio
  class Ability
    include CanCan::Ability

    def initialize(user, ip_address = nil)
      case user.try(:role).try(:name)
      when 'Administrator'
        can :manage, [
          AgentMerge,
          AgentMergeList,
          Donate,
          Identifier,
          ManifestationRelationship,
          ManifestationRelationshipType,
          Agent,
          AgentImportFile,
          AgentRelationship,
          AgentRelationshipType,
          FormOfWork,
          PictureFile,
          ResourceExportFile,
          SeriesStatement,
          SeriesStatementMerge,
          SeriesStatementMergeList
        ]
        can :manage, [
          Country,
          MediumOfPerformance,
        ] if LibraryGroup.site_config.network_access_allowed?(ip_address)
        can :read, [
          Country,
          FormOfWork,
          MediumOfPerformance,
          AgentImportResult,
        ]
      when 'Librarian'
        can [:index, :create], Agent
        can :show, Agent do |agent|
          agent.required_role_id <= 3
        end
        can [:update, :destroy, :delete], Agent do |agent|
          agent.required_role_id <= 3
        end
        can :manage, [
          AgentMerge,
          AgentMergeList,
          Donate,
          Identifier,
          ManifestationRelationship,
          AgentImportFile,
          AgentRelationship,
          PictureFile,
          ResourceExportFile,
          SeriesStatement,
          SeriesStatementMerge,
          SeriesStatementMergeList
        ]
        can :read, [
          Country,
          FormOfWork,
          ManifestationRelationshipType,
          AgentImportResult,
          AgentRelationshipType,
          MediumOfPerformance
        ]
      when 'User'
        can :index, Agent
        can :show, Agent do |agent|
          true if agent.required_role_id <= 2 #name == 'Administrator'
        end
        can :index, PictureFile
        can :show, PictureFile do |picture_file|
          begin
            true if picture_file.picture_attachable.required_role_id <= 2
          rescue NoMethodError
            true
          end
        end
        can :read, [
          Country,
          FormOfWork,
          Identifier,
          ManifestationRelationship,
          ManifestationRelationshipType,
          MediumOfPerformance,
          AgentRelationship,
          AgentRelationshipType,
          SeriesStatement
        ]
      else
        can :index, Agent
        can :show, Agent do |agent|
          agent.required_role_id == 1 #name == 'Guest'
        end
        can :read, [
          Country,
          FormOfWork,
          Identifier,
          ManifestationRelationship,
          ManifestationRelationshipType,
          MediumOfPerformance,
          AgentRelationship,
          AgentRelationshipType,
          PictureFile,
          SeriesStatement
        ]
      end
    end
  end
end
