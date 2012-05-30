class Ability
  include CanCan::Ability

  def initialize(user, ip_addess = nil)
    case user.try(:role).try(:name)
    when 'Administrator'
      can :manage, Create
      can :manage, CreateType
      can :manage, Realize
      can :manage, RealizeType
      can :manage, Produce
      can :manage, ProduceType
      can :manage, Manifestation
    when 'Librarian'
      can :manage, Create
      can :manage, Realize
      can :manage, Produce
      can :manage, Manifestation
    when 'User'
      can :read, Create
      can :read, Realize
      can :read, Produce
      can :read, Manifestation do |manifestation|
        manifestation.required_role_id <= 2
      end
    else
      can :read, Create
      can :read, Realize
      can :read, Produce
      can :read, Manifestation do |manifestation|
        manifestation.required_role_id <= 1
      end
    end
  end
end
