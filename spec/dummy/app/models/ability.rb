class Ability
  include CanCan::Ability

  def initialize(user, ip_addess = nil)
    case user.try(:role).try(:name)
    when 'Administrator'
      can [:index, :update], Country
      can :manage, Create
      can :manage, CreateType
      can [:index, :update], Language
      can :manage, Realize
      can :manage, RealizeType
      can :manage, Produce
      can :manage, ProduceType
      can :manage, Manifestation
    when 'Librarian'
      can :read, Country
      can :manage, Create
      can :read, Language
      can :manage, Realize
      can :manage, Produce
      can :manage, Manifestation
    when 'User'
      can :read, Country
      can :read, Create
      can :read, Language
      can :read, Realize
      can :read, Produce
      can :read, Manifestation do |manifestation|
        manifestation.required_role_id <= 2
      end
    else
      can :read, Country
      can :read, Create
      can :read, Language
      can :read, Realize
      can :read, Produce
      can :read, Manifestation do |manifestation|
        manifestation.required_role_id <= 1
      end
    end
  end
end
