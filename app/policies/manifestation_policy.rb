class ManifestationPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    case user.try(:role).try(:name)
    when 'Librarian'
      true
    when 'User'
      true if record.required_role_id <= 2
    else
      true if record.required_role_id <= 1
    end
  end

  def create?
    true if user.try(:has_role?, 'Librarian')
  end

  def edit?
    case user.try(:role).try(:name)
    when 'Librarian'
      true
    when 'User'
      true if record.required_role_id <= 2
    end
  end

  def update?
    true if user.try(:has_role?, 'Librarian')
  end

  def destroy?
    if user.try(:has_role?, 'Librarian')
      if  record.items.empty?
        if record.series_master?
          if record.children.empty?
            true
          else
            false
          end
        else
          true
        end
      end
    end
  end
end
