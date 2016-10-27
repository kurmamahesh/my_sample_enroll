require 'rails_helper'

RSpec.describe HbxProfile, :type => :model do
  let(:organization) { FactoryGirl.create(:organization) }

  let(:cms_id)  { "DC0" }
  let(:us_state_abbreviation)  { "DC" }
  let(:markets) { %w(shop unassisted_individual assisted_individual non_aca) }
  let(:valid_params) {
    {
      organization: organization,
      cms_id: cms_id,
      us_state_abbreviation: us_state_abbreviation
    }
  }

  context ".new" do
    context "with no organization" do
      let(:params) {valid_params.except(:organization)}

      it "should raise" do
        expect{HbxProfile.create(**params)}.to raise_error(Mongoid::Errors::NoParent)
      end
    end

    context "with all required data", dbclean: :before do
      let(:params)        { valid_params }
      let(:hbx_profile)   { HbxProfile.new(**params) }
      before :all do
        @hp_count = HbxProfile.all.size
      end

      it "should save" do
        expect(hbx_profile.save).to be_truthy
      end

      context "and it is saved" do
        let!(:saved_hbx_profile) do
          hbx = HbxProfile.new(**params)
          hbx.save
          hbx
        end

        it "should return all HBX instances" do
          expect(HbxProfile.all.size).to eq @hp_count + 2
        end

        it "should be findable by ID" do
          expect(HbxProfile.find(saved_hbx_profile._id)).to eq saved_hbx_profile
        end

      end
    end
  end
end
