require 'spec_helper'

describe "dashboard", js: true  do
	let(:doctor_attr) { attributes_for :doctor}
	let(:diabetic_attr) {  attributes_for :diabetic }
	let!(:account) { create :account }
	let!(:doctor) { create :doctor  }
	let!(:diabetic) { create :diabetic, account: account, doctor: doctor }
	let(:record) { create :record, diabetic: diabetic  }

	before(:each) do
		stub_current_account(account)
    visit account_path(account)
	end


  describe "User reaches the dashboard" do
    it "by logging in an existing account" do
      expect(page).to have_css("form")
      expect(page).to have_css("select")
      expect(page.body).to have_content("Dashboard")
    end
  end

	context "with account" do
		it "user can edit the account information" do
			username = "tester_username_that_should_be_new"
			email = "tester_email@should_be_new.com"
			password = "testing"
			find("option[value='Account: #{account.username}']").click
			click_on "Edit the account"
			wait_for_ajax
			fill_in "account[username]", with: username
			fill_in "account[email]", with: email
			fill_in "account[password]", with: password
			click_on "Save"
			wait_for_ajax
			expect(account.reload.username).to eq(username)
			expect(account.reload.email).to eq(email)
			expect(page.body).to have_content("Dashboard")
		end

		it "user can cancel the edit the account information" do
			find("option[value='Account: #{account.username}']").click
			wait_for_ajax
			click_on "Edit the account"
			wait_for_ajax
			click_on "Cancel"
			wait_for_ajax
			expect(page.body).to have_content("Dashboard")
		end

		it "user can add a diabetic" do
			find("option[value='Account: #{account.username}']").click
			#Adds a diabetic
			click_on "Add a Diabetic"
			wait_for_ajax
			expect{
				fill_in "diabetic[name]", with: diabetic_attr[:name]
				fill_in "diabetic[email]", with: diabetic_attr[:email]
				within '#diabetic_birthday_1i' do
					find("option[value='2009']").click
				end
				click_on "Create"
				wait_for_ajax
			}.to change{Diabetic.count}.by(1)
			expect(account.diabetics.last.name).to eq(diabetic_attr[:name])
			expect(account.diabetics.last.email).to eq(diabetic_attr[:email])

			#Adds a doctor to the diabetic
			fill_in "doctor[name]", with: doctor_attr[:name]
			fill_in "doctor[fax]", with: doctor_attr[:fax]
			fill_in "doctor[email]", with: doctor_attr[:email]
			fill_in "doctor[comments]", with: doctor_attr[:comments]
			click_on "Save Doctor"
			wait_for_ajax
			expect(account.reload.diabetics.last.doctor.name).to eq(doctor_attr[:name])
			expect(account.reload.diabetics.last.doctor.fax).to eq(doctor_attr[:fax])
			expect(account.reload.diabetics.last.doctor.email).to eq(doctor_attr[:email])
			expect(account.reload.diabetics.last.doctor.comments).to eq(doctor_attr[:comments])

			#adds preference to diabetic
			choose "preference_reminders_false"
			find("option[value='2']").click
			click_on "Save"
			wait_for_ajax
			expect(account.reload.diabetics.last.preference.reminders).to eq(false)
			expect(account.reload.diabetics.last.preference.frequency).to eq(2)

			expect(page.body).to have_content("Dashboard")
		end

		it "user can cancel the add a diabetic" do
			find("option[value='Account: #{account.username}']").click
			click_on "Add a Diabetic"
			wait_for_ajax
			click_on "Cancel"
			wait_for_ajax
			expect(page.body).to have_content("Dashboard")
		end

	end

	context "with diabetics" do
		it "can add a record for diabetic" do
			diabetic_name = account.diabetics.first.name
			diabetic_id = account.diabetics.first.id
			find("option[value='Diabetic: #{diabetic_name.gsub("'","\'")} -- #{diabetic_id} ']").click
			click_on "Add record for: #{account.diabetics.first.name}"
			wait_for_ajax
			weight = rand(175..230)
			glucose = rand(200..600)
			fill_in "record[weight]", with: weight
			fill_in "record[glucose]", with: glucose
			fill_in "record[comment]", with: "test_comment"
			expect{
				click_on "Add"
				wait_for_ajax
				}.to change{Record.count}.by(1)
			expect(account.diabetics.first.records.last.weight.to_i).to eq(weight)
			expect(account.diabetics.first.records.last.glucose.to_i).to eq(glucose)
			expect(account.diabetics.first.records.last.comment).to eq("test_comment")
			expect(page.body).to have_content("Dashboard")
		end


		context "edit the diabetic's info" do
			before(:each) do
				diabetic_name = diabetic.name
				diabetic_id = diabetic.id
				find("option[value='Diabetic: #{diabetic_name.gsub("'","\'")} -- #{diabetic_id} ']").click
				wait_for_ajax
				click_on "Edit #{diabetic_name.gsub("'","\'")}'s info"
				wait_for_ajax
			end

			it "can edit preferences" do
				click_on "Add Preferences"
				wait_for_ajax
				choose "preference_reminders_false"
				find("option[value='2']").click
				click_on "Save"
				wait_for_ajax
				expect(diabetic.preference.reminders).to eq(false)
				expect(diabetic.preference.frequency).to eq(2)
				expect(page.body).to have_content("Dashboard")
			end

			it "can edit user info" do
				click_on "Edit User Info"
				wait_for_ajax
				expect{
					fill_in "diabetic[name]", with: diabetic_attr[:name]
					fill_in "diabetic[email]", with: diabetic_attr[:email]
					within '#diabetic_birthday_1i' do
						find("option[value='2009']").click
					end
					click_on "Save"
					wait_for_ajax
				}.to change{Diabetic.count}.by(0)
				expect(account.diabetics.reload.last.name).to eq(diabetic_attr[:name])
				expect(account.diabetics.reload.last.email).to eq(diabetic_attr[:email])
				expect(page.body).to have_content("Dashboard")
			end

			it "can edit doctor info" do
				click_on "Edit Doctor Info"
				wait_for_ajax
				fill_in "doctor[name]", with: doctor_attr[:name]
				fill_in "doctor[fax]", with: doctor_attr[:fax]
				fill_in "doctor[email]", with: doctor_attr[:email]
				fill_in "doctor[comments]", with: doctor_attr[:comments]
				click_on "Save Doctor"
				wait_for_ajax
				expect(diabetic.doctor.reload.name).to eq(doctor_attr[:name])
				expect(diabetic.doctor.reload.fax).to eq(doctor_attr[:fax])
				expect(diabetic.doctor.reload.email).to eq(doctor_attr[:email])
				expect(diabetic.doctor.reload.comments).to eq(doctor_attr[:comments])
				expect(page.body).to have_content("Dashboard")
			end

		end



	end

end