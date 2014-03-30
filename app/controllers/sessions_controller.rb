class SessionsController < ApplicationController

  before_filter :redirect_if_logged_in,  :only => [:new]
  before_filter :redirect_if_logged_out,  :only => [:destroy]

  def new
    @account = Account.new
    render :partial => 'sessions/new', :locals => { :account => @account }
  end

  def create
    account = Account.find_by_username(params[:username]).try(:authenticate, params[:password])
    if account
      ok = true
      login account
      path = account_path(account)
    else
      alert = 'invalid login information'
      path = root_path
    end
    render_json(!!ok, path, alert)
  end

  def destroy
    ok = true
    reset_session
    render_json(!!ok, root_path, 'You have been logged out')
  end
end
