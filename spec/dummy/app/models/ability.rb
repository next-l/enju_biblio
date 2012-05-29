class Ability
  include CanCan::Ability

  def initialize(user)
    case user.try(:role).try(:name)
    when 'Administrator'
      can :read, Create
      can :read, CreateType
      can :read, Realize
      can :read, RealizeType
    when 'Librarian'
      can :read, Create
      can :read, CreateType
      can :read, Realize
      can :read, RealizeType
    when 'User'
      can :read, Create
      can :read, CreateType
      can :read, Realize
      can :read, RealizeType
    else
      can :read, Create
      can :read, CreateType
      can :read, Realize
      can :read, RealizeType
    end
  end
end
