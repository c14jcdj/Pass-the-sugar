require 'spec_helper'


describe "Accounts", :js => true do
  let(:account) {create :account}
  let!(:pre_existing_account) {create :account}
  let(:diabetic) {create :diabetic}
  let(:diabetic_attr) {  attributes_for :diabetic }
  let(:doctor_attr) {  attributes_for :doctor }

  describe "full account creation process" do

    context "all valid, none-existing input" do
      it 'allows user to create an account with sign up with valid inputs' do
        visit root_path
        click_on "Sign Up"
        wait_for_ajax
        expect{
          fill_in "Username", with: 'business'
          fill_in "Email", with: 'business@business.com'
          fill_in "Password", with: 'business'
          fill_in "Password Confirmation", with: 'business'
          click_on "Sign up"
          wait_for_ajax
        }.to change{Account.count}.by(1)
        expect(page).to have_content 'Add a diabetic'
        expect(Account.last.username).to eq('business')
        expect(Account.last.email).to eq('business@business.com')

        new_account = Account.last

        expect{
          fill_in "diabetic[name]", with: diabetic_attr[:name]
          fill_in "diabetic[email]", with: diabetic_attr[:email]
          find("option[value='2009']").click
          click_on "Create"
          wait_for_ajax
        }.to change{Diabetic.count}.by(1)
        expect(new_account.diabetics.last.name).to eq(diabetic_attr[:name])
        expect(new_account.diabetics.last.email).to eq(diabetic_attr[:email])
        expect(page).to have_content 'Create a Doctor'

        expect{
          fill_in "doctor[name]", with: doctor_attr[:name]
          fill_in "doctor[fax]", with: doctor_attr[:fax]
          fill_in "doctor[email]", with: doctor_attr[:email]
          fill_in "doctor[comments]", with: doctor_attr[:comments]
          click_on "Save Doctor"
          wait_for_ajax
        }.to change{Doctor.count}.by(1)
        expect(new_account.reload.diabetics.last.doctor.name).to eq(doctor_attr[:name])
        expect(new_account.reload.diabetics.last.doctor.fax).to eq(doctor_attr[:fax])
        expect(new_account.reload.diabetics.last.doctor.email).to eq(doctor_attr[:email])
        expect(new_account.reload.diabetics.last.doctor.comments).to eq(doctor_attr[:comments])
        expect(page).to have_content 'preferences'

        expect{
          find("option[value='2']").click
          click_on "Save"
          wait_for_ajax
        }.to change{Preference.count}.by(1)
        expect(new_account.reload.diabetics.last.preference.reminders).to eq(true)
        expect(new_account.reload.diabetics.last.preference.frequency).to eq(2)
        expect(page).to have_content 'Dashboard'
      end
    end

    context "with pre-existing inputs" do
      it "with none-unique account name" do
        visit root_path
        click_on "Sign Up"
        wait_for_ajax
        expect{
          fill_in "Username", with: pre_existing_account.username
          fill_in "Email", with: 'business@business.com'
          fill_in "Password", with: 'business'
          fill_in "Password Confirmation", with: 'business'
          click_on "Sign up"
          wait_for_ajax
        }.to change{Account.count}.by(0)
        expect(page).to have_content 'Username has already been taken'
      end
      it "with none-unique account email" do
        visit root_path
        click_on "Sign Up"
        wait_for_ajax
        expect{
          fill_in "Username", with: 'business'
          fill_in "Email", with: pre_existing_account.email
          fill_in "Password", with: 'business'
          fill_in "Password Confirmation", with: 'business'
          click_on "Sign up"
          wait_for_ajax
        }.to change{Account.count}.by(0)
      end
    end

    context "with invalid inputs" do
      it "with blank username" do
        visit root_path
        click_on "Sign Up"
        wait_for_ajax
        expect{
          fill_in "Email", with: 'business@business.com'
          fill_in "Password", with: 'business'
          fill_in "Password Confirmation", with: 'business'
          click_on "Sign up"
          wait_for_ajax
        }.to change{Account.count}.by(0)
        expect(page).to have_content "Username can't be blank"
      end
      it "with blank email" do
        visit root_path
        click_on "Sign Up"
        wait_for_ajax
        expect{
          fill_in "Username", with: 'business'
          fill_in "Password", with: 'business'
          fill_in "Password Confirmation", with: 'business'
          click_on "Sign up"
          wait_for_ajax
        }.to change{Account.count}.by(0)
        expect(page).to have_content "Email is invalid"
      end
      it "with invalid email" do
        visit root_path
        click_on "Sign Up"
        wait_for_ajax
        expect{
          fill_in "Username", with: 'business'
          fill_in "Email", with: 'fty6yuhe'
          fill_in "Password", with: 'business'
          fill_in "Password Confirmation", with: 'business'
          click_on "Sign up"
          wait_for_ajax
        }.to change{Account.count}.by(0)
        expect(page).to have_content "Email is invalid"
      end
      it "with password shorter than 5 characters" do
        visit root_path
        click_on "Sign Up"
        wait_for_ajax
        expect{
          fill_in "Email", with: 'business@business.com'
          fill_in "Password", with: 'busi'
          fill_in "Password Confirmation", with: 'business'
          click_on "Sign up"
          wait_for_ajax
        }.to change{Account.count}.by(0)
        expect(page).to have_content "Password is too short (minimum is 5 characters)"
      end
    end

    it "user can cancel account creation" do
      visit root_path
      click_on "Sign Up"
      wait_for_ajax
      expect{
        click_on "Cancel"
        wait_for_ajax
      }.to change{Account.count}.by(0)
      expect(current_path).to eq(root_path)
    end

    context "user can cancel and exit the account creation chain early with account still created" do
      it "at add a diabetic" do
        expect{
          visit root_path
          click_on "Sign Up"
          wait_for_ajax
          fill_in "Username", with: 'business'
          fill_in "Email", with: 'business@business.com'
          fill_in "Password", with: 'business'
          fill_in "Password Confirmation", with: 'business'
          click_on "Sign up"
          wait_for_ajax
          click_on "Cancel"
        }.to change{Account.count}.by(1)
        expect(page).to have_content 'Dashboard'
      end
      it "at add a doctor" do
        expect{
          visit root_path
          click_on "Sign Up"
          wait_for_ajax
          fill_in "Username", with: 'business'
          fill_in "Email", with: 'business@business.com'
          fill_in "Password", with: 'business'
          fill_in "Password Confirmation", with: 'business'
          click_on "Sign up"
          wait_for_ajax
          fill_in "diabetic[name]", with: diabetic_attr[:name]
          fill_in "diabetic[email]", with: diabetic_attr[:email]
          find("option[value='2009']").click
          click_on "Create"
          wait_for_ajax
          click_on "Cancel"
        }.to change{Account.count}.by(1)
        expect(page).to have_content 'Dashboard'
      end
      it "at add a preference" do
        expect{
          visit root_path
          click_on "Sign Up"
          wait_for_ajax
          fill_in "Username", with: 'business'
          fill_in "Email", with: 'business@business.com'
          fill_in "Password", with: 'business'
          fill_in "Password Confirmation", with: 'business'
          click_on "Sign up"
          wait_for_ajax
          fill_in "diabetic[name]", with: diabetic_attr[:name]
          fill_in "diabetic[email]", with: diabetic_attr[:email]
          find("option[value='2009']").click
          click_on "Create"
          wait_for_ajax
          fill_in "doctor[name]", with: doctor_attr[:name]
          fill_in "doctor[fax]", with: doctor_attr[:fax]
          fill_in "doctor[email]", with: doctor_attr[:email]
          fill_in "doctor[comments]", with: doctor_attr[:comments]
          click_on "Save Doctor"
          wait_for_ajax
          click_on "Cancel"
        }.to change{Account.count}.by(1)
        expect(page).to have_content 'Dashboard'
      end

    end


  end
end
