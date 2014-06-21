class ResourceExportFilePolicy < AdminPolicy
  def index?
    user.try(:has_role?, 'User')
  end

  def show?
    user.try(:has_role?, 'User')
  end

  def create?
    user.try(:has_role?, 'User')
  end

  def update?
    user.try(:has_role?, 'Librarian')
  end

  def destroy?
    user.try(:has_role?, 'Librarian')
  end
end
