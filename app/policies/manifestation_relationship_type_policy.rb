class ManifestationRelationshipTypePolicy < AdminPolicy
  def index
    user.try(:has_role?, 'User')
  end

  def create?
    user.try(:has_role?, 'Administrator')
  end

  def update?
    user.try(:has_role?, 'Administrator')
  end

  def destroy?
    user.try(:has_role?, 'Administrator')
  end
end
