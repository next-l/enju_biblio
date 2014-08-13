module EnjuBiblio
  class Ability
    include CanCan::Ability

    def initialize(user, ip_address = nil)
      case user.try(:role).try(:name)
      when 'Administrator'
        can [:read, :create, :update], CarrierType
        can [:destroy, :delete], CarrierType do |carrier_type|
          true unless carrier_type.manifestations.exists?
        end if LibraryGroup.site_config.network_access_allowed?(ip_address)
        can [:read, :create, :update], IdentifierType
        can [:destroy, :delete], IdentifierType do |identifier_type|
          true unless identifier_type.identifiers.exists?
        end if LibraryGroup.site_config.network_access_allowed?(ip_address)
        can [:read, :create, :update], Item
        can [:destroy, :delete], Item do |item|
          item.removable?
        end
        can [:read, :create, :update], Manifestation
        can [:destroy, :delete], Manifestation do |manifestation|
          manifestation.items.empty? and !manifestation.series_master?
        end
        can :manage, [
          Create,
          CreateType,
          Donate,
          Identifier,
          ImportRequest,
          ManifestationRelationship,
          ManifestationRelationshipType,
          Own,
          Agent,
          AgentImportFile,
          AgentRelationship,
          AgentRelationshipType,
          FormOfWork,
          PictureFile,
          Produce,
          ProduceType,
          Realize,
          RealizeType,
          ResourceImportFile,
          ResourceExportFile,
          SeriesStatement
        ]
        can :manage, [
          ContentType,
          Country,
          Extent,
          Frequency,
          Language,
          License,
          MediumOfPerformance,
          AgentType
        ] if LibraryGroup.site_config.network_access_allowed?(ip_address)
        can :read, [
          CarrierType,
          ContentType,
          Country,
          Extent,
          Frequency,
          FormOfWork,
          IdentifierType,
          Language,
          License,
          MediumOfPerformance,
          AgentImportResult,
          AgentType,
          ResourceImportResult
        ]
      when 'Librarian'
        can :manage, Item
        can :index, Manifestation
        can [:show, :create, :update], Manifestation
        can [:destroy, :delete], Manifestation do |manifestation|
          manifestation.items.empty? and !manifestation.series_master?
        end
        can [:index, :create], Agent
        can :show, Agent do |agent|
          agent.required_role_id <= 3
        end
        can [:update, :destroy, :delete], Agent do |agent|
          agent.required_role_id <= 3
        end
        can :manage, [
          Create,
          Donate,
          Identifier,
          ImportRequest,
          ManifestationRelationship,
          Own,
          AgentImportFile,
          AgentRelationship,
          PictureFile,
          Produce,
          Realize,
          ResourceImportFile,
          ResourceExportFile,
          SeriesStatement
        ]
        can :read, [
          CarrierType,
          ContentType,
          Country,
          Extent,
          Frequency,
          FormOfWork,
          IdentifierType,
          Language,
          License,
          ManifestationRelationshipType,
          AgentImportResult,
          AgentRelationshipType,
          AgentType,
          ResourceImportResult,
          MediumOfPerformance
        ]
      when 'User'
        can :index, Item
        can :show, Item do |item|
          item.required_role_id <= 2
        end
        can :index, Manifestation
        can [:show, :edit], Manifestation do |manifestation|
          manifestation.required_role_id <= 2
        end
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
          CarrierType,
          ContentType,
          Country,
          Create,
          Extent,
          Frequency,
          FormOfWork,
          Identifier,
          IdentifierType,
          Language,
          License,
          ManifestationRelationship,
          ManifestationRelationshipType,
          MediumOfPerformance,
          Own,
          AgentRelationship,
          AgentRelationshipType,
          Produce,
          Realize,
          SeriesStatement
        ]
      else
        can :index, Manifestation
        can :show, Manifestation do |manifestation|
          manifestation.required_role_id == 1
        end
        can :index, Agent
        can :show, Agent do |agent|
          agent.required_role_id == 1 #name == 'Guest'
        end
        can :read, [
          CarrierType,
          ContentType,
          Country,
          Create,
          Extent,
          Frequency,
          FormOfWork,
          Identifier,
          IdentifierType,
          Item,
          Language,
          License,
          ManifestationRelationship,
          ManifestationRelationshipType,
          MediumOfPerformance,
          Own,
          AgentRelationship,
          AgentRelationshipType,
          PictureFile,
          Produce,
          Realize,
          SeriesStatement
        ]
      end
    end
  end
end
