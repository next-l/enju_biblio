class Ability
  include CanCan::Ability

  def initialize(user, ip_addess = nil)
    case user.try(:role).try(:name)
    when 'Administrator'
      can [:read, :update], Country
      can :manage, Create
      can :manage, CreateType
      can [:read, :update], Frequency
      can [:read, :update], FormOfWork
      can [:read, :create, :update], Item
      can :destroy, Item do |item|
        item.deletable?
      end
      can [:read, :update], Language
      can [:read, :update], License
      can [:read, :update], MediumOfPerformance
      can [:read, :create, :update], Patron
      can :destroy, Patron do |patron|
        true
      end
      can :manage, PatronRelationship
      can :manage, PatronRelationshipType
      can :manage, Produce
      can :manage, ProduceType
      can :manage, Manifestation
      can :manage, ManifestationRelationship
      can :manage, ManifestationRelationshipType
      can :manage, Realize
      can :manage, RealizeType
      can :manage, SeriesHasManifestation
      can :manage, SeriesStatement
    when 'Librarian'
      can :read, Country
      can :manage, Create
      can :read, Frequency
      can :read, FormOfWork
      can [:read, :create, :update], Item
      can :destroy, Item do |item|
        if defined?(EnjuCirculation)
          item.checkouts.not_returned.empty?
        else
          true
        end
      end
      can :read, Language
      can :read, License
      can :read, MediumOfPerformance
      can [:index, :create], Patron
      can [:show, :update, :destroy], Patron do |patron|
        patron.required_role_id <= 3
      end
      can :manage, PatronRelationship
      can :read, PatronRelationshipType
      can :manage, Produce
      can :manage, Manifestation
      can :manage, ManifestationRelationship
      can :read, ManifestationRelationshipType
      can :manage, Realize
      can :manage, SeriesHasManifestation
      can :manage, SeriesStatement
    when 'User'
      can :read, Country
      can :read, Create
      can :read, Frequency
      can :read, FormOfWork
      can :index, Item
      can :show, Item do |item|
        item.required_role_id <= 2
      end
      can :read, Language
      can :read, License
      can :read, MediumOfPerformance
      can :index, Patron
      can :show, Patron do |patron|
        true if patron.required_role_id <= 2
      end
      can :read, PatronRelationship
      can :read, PatronRelationshipType
      can :read, Produce
      can :read, Manifestation do |manifestation|
        manifestation.required_role_id <= 2
      end
      can :read, ManifestationRelationship
      can :read, ManifestationRelationshipType
      can :read, Realize
      can :read, SeriesHasManifestation
      can :read, SeriesStatement
    else
      can :read, Country
      can :read, Create
      can :read, Frequency
      can :read, FormOfWork
      can :read, Item
      can :read, Language
      can :read, License
      can :read, MediumOfPerformance
      can :index, Patron
      can :show, Patron do |patron|
        true if patron.required_role_id <= 1
      end
      can :read, PatronRelationship
      can :read, PatronRelationshipType
      can :read, Produce
      can :read, Manifestation do |manifestation|
        manifestation.required_role_id <= 1
      end
      can :read, ManifestationRelationship
      can :read, ManifestationRelationshipType
      can :read, Realize
      can :read, SeriesHasManifestation
      can :read, SeriesStatement
    end
  end
end
