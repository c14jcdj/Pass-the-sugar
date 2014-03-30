require 'spec_helper'

describe AccountsController do
  let!(:account) { create :account }


  context '#create' do
    it "creates with valid attributes" do
      request.env["HTTP_REFERER"] = new_session_path
      expect {
        post :create, :account => {username: 'test1',
                                   email: 'test@test1.com',
                                   password: 'testing1',
                                   password_confirmation: 'testing1'}
      }.to change { Account.count }.by(1)
    end

    it "doesn't create if attributes are invalid" do
      request.env["HTTP_REFERER"] = new_session_path
      expect {
        post :create, :account => {}
      }.to_not change { Account.count }.by(1)
    end

  end

  context '#new' do
    it 'is sucessful' do
      expect(response).to be_success
    end

    it 'redirects if logged_in' do
      request.env["HTTP_REFERER"] = new_session_path
      session[:account_id] = account.id
      get :new
      expect(response).to be_redirect
    end

    it 'sets :account to new instance of Account' do
      get :new
      expect(response).to render_template(:partial => 'shared/sign_up',
                                          :locals => {:account => Account.new})
    end
  end

  context 'edit' do
    it 'is sucessful' do
      expect(response).to be_success
    end

    it 'redirects if logged out' do
      request.env["HTTP_REFERER"] = new_session_path
      get :edit, id: account.id
      expect(response).to be_redirect
    end

    it 'sets @account to Account to be edited' do
      request.env["HTTP_REFERER"] = new_session_path
      session[:account_id] = account.id
      get :edit, id: account.id
      expect(assigns(:account)).to eq(Account.find(account.id))
    end
  end


  context 'update' do
    it 'updates username if password is correct' do
      request.env["HTTP_REFERER"] = new_session_path
      session[:account_id] = account.id
      put :update, id: account.id, 'account' => {'username' => 'test1',
                                                 'email' => 'test@test1.com',
                                                 'password' => 'testing',
                                                 'password_confirmation' => 'testing'}
      expect{
      account.reload.username}.to change{account.username}.to "test1"
    end
    it 'updates email if password is correct' do
      request.env["HTTP_REFERER"] = new_session_path
      session[:account_id] = account.id
      put :update, id: account.id, 'account' => {'username' => 'test1',
                                                 'email' => 'test@test1.com',
                                                 'password' => 'testing',
                                                 'password_confirmation' => 'testing'}
      expect{
      account.reload.email}.to change{account.email}.to "test@test1.com"
    end

    it "doesn't update email if password is correct" do
      request.env["HTTP_REFERER"] = edit_account_path(account.id)
      put :update, id: account.id, 'account' => {'username' => 'test1',
                                                 'email' => 'test@test1.com',
                                                 'password' => 'testing1',
                                                 'password_confirmation' => 'testing1'}
      expect{
      account.reload.email}.to_not change{account.email}.to "test@test1.com"
    end

    it 'redirects if logged out' do
      request.env["HTTP_REFERER"] = new_session_path
      put :update, id: account.id
      expect(response).to be_redirect
    end
  end

  context 'change password' do
    it 'update new password if password is authorized and confirmed' do
      request.env["HTTP_REFERER"] = edit_account_path(account.id)
      session[:account_id] = account.id
      expect{
        put :change_password,
          :new_password => 'newpassword',
          :password_confirmation => 'newpassword',
          :password => 'testing'

      }.to change{ Account.find(account.id).authenticate('testing') }.to false
    end

    it 'redirects if logged out' do
      request.env["HTTP_REFERER"] = edit_account_path(account.id)
      put :change_password
      expect(response).to be_redirect
    end

    it 'does not update new password if password is not authorized and confirmed' do
      request.env["HTTP_REFERER"] = edit_account_path(account.id)
      expect{
        put :change_password,  'account' => {
          'id' => account.id,
          'new_password' => 'newpassword',
          'password_confirmation' => 'newpassword',
        'password' => 'testing1'}
      }.to_not change{ Account.find(account.id).authenticate('testing') }.to false
    end
  end

end
