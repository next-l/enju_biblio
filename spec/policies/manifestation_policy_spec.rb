require "rails_helper"

describe ManifestationPolicy do
  subject { described_class }
  permissions :destroy? do
    before(:each) do
      @admin = FactoryGirl.create(:admin)
    end
    it "grants destroy if it is a simple record." do
      record = FactoryGirl.create(:manifestation)
      expect(subject).to permit(@admin, record)
    end
    it "not grants destroy if it is reserved" do
      record = FactoryGirl.create(:manifestation)
      reserve = FactoryGirl.create(:reserve, manifestation_id: record.id)
      expect(subject).not_to permit(@admin, record)
    end
    it "grants destroy if it is a simple serial record." do
      record = FactoryGirl.create(:manifestation_serial)
      policy = Pundit.policy(@admin, record)
      expect(subject).to permit(@admin, record)
    end
  end
end
