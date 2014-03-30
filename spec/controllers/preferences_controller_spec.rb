require 'spec_helper'

describe PreferencesController do
  let(:preference) { create :preference }
  let(:pref_attr) { attributes_for :preference }
  let!(:account) { create :account }
  let!(:pre_created_pref) { create :preference }
  #added account accociation for diabetics fixed it
  let(:diabetic) { create :diabetic, account: account }




#seems like it's the create account that's fucking it up.
#whenever account is called, it breaks diabetics
  before(:each) do
    stub_current_account(account)
  end


  context "#new" do
    it "should successfully render a page for a diabetic" do
      get :new, diabetic_id: diabetic.id
      expect(response).to be_success
      expect(assigns(:diabetic)).to eq(diabetic)
    end
  end

  context "#show" do
    it "should successfully render a page" do
      diabetic.preference = preference
      diabetic.save
      get :show, id: diabetic.preference.id, diabetic_id: diabetic.id
      expect(response).to be_success
    end
    it "should display this specific doctor" do
      diabetic.preference = preference
      diabetic.save
      get :show, id: diabetic.preference.id, diabetic_id: diabetic.id
      expect(assigns(:diabetic)).to eq(diabetic)
      expect(assigns(:preference)).to eq(preference)
    end
  end

  context "#create" do
    it "should increase preference count if preference for this diabetic don't already exist" do
      expect{
        post :create, preference: pref_attr, diabetic_id: diabetic.id
      }.to change{Preference.count}.by(1)
    end
    it "should not increase preference count if preference for this diabetic already exists" do
      diabetic.preference = preference
      diabetic.save
      expect{
        post :create, preference: pref_attr, diabetic_id: diabetic.id
      }.to_not change{Preference.count}
    end
    it "should update preference if preference for this diabetic already exists" do
      diabetic.preference = pre_created_pref
      diabetic.save
      expect{
        post :create, preference: pref_attr, diabetic_id: diabetic.id
      }.to_not change{Preference.count}
      expect(diabetic.preference.reminders).to eq(pref_attr[:reminders])
      expect(diabetic.preference.frequency).to eq(pref_attr[:frequency])
    end
  end

  context "#edit" do
    it "should render edit page with the right diabetic and preference" do
      diabetic.preference = pre_created_pref
      diabetic.save
      get :edit, id: pre_created_pref.id, diabetic_id: diabetic.id
      expect(response).to be_success
      expect(assigns(:diabetic)).to eq(diabetic)
      expect(assigns(:preference)).to eq(pre_created_pref)
    end
  end

  context "#update" do
    it "should update preference for the diabetic" do
      diabetic.preference = pre_created_pref
      diabetic.save
      expect{
        put :create, preference: pref_attr, diabetic_id: diabetic.id, id: diabetic.preference.id
      }.to_not change{Preference.count}
      expect(diabetic.preference.reminders).to eq(pref_attr[:reminders])
      expect(diabetic.preference.frequency).to eq(pref_attr[:frequency])
    end
  end
end
