module EnjuBiblio
  class Ability
    include CanCan::Ability

    def initialize(user, ip_address = nil)
    end
  end
end
