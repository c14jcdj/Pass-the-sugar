require 'spec_helper'

describe "dashboard", js: true  do
	let!(:account) { create :account }

	before(:each) do
    visit new_session_path
    fill_in "Username", with: account.username
    fill_in "Password", with: account.password
    click_on "Log in"
    visit account_path(account)
	end

	 describe "User can log out from the dashboard" do
    it "by clicking on 'Logout'" do
    	click_on "Logout"
    	expect(page).to have_content("Log In")
    	expect(page).to_not have_content("Dashboard")
    	expect(page.current_path).to eq root_path
    end
  end

end