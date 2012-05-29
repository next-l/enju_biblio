class Ability
  include CanCan::Ability

  def initialize(user)
    case user.try(:role).try(:name)
    when 'Administrator'
      can :manage, Create
      can [:read, :update], CreateType
      can :manage, Realize
      can [:read, :update], RealizeType
    when 'Librarian'
      can :manage, Create
      can :manage, Realize
    when 'User'
      can :read, Create
      can :read, Realize
    else
      can :read, Create
      can :read, Realize
    end
  end
end
