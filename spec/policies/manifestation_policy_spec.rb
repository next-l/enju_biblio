require "rails_helper"

describe ManifestationPolicy do
  subject { described_class }
  permissions :destroy? do
    before(:each) do
      @admin = FactoryBot.create(:admin)
    end

    it "grants destroy if it is a simple record." do
      record = FactoryBot.create(:manifestation)
      expect(subject).to permit(@admin, record)
    end

    it "grants destroy if it is a simple serial record." do
      record = FactoryBot.create(:manifestation_serial)
      policy = Pundit.policy(@admin, record)
      expect(subject).to permit(@admin, record)
    end
  end
end
