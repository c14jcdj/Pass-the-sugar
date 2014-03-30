class AccountsController < ApplicationController
    before_filter :redirect_if_logged_in,  :only => [:new, :index]
    before_filter :redirect_if_logged_out,  :except => [:new, :create, :index]
    before_filter :redirect_unless_authorized, :only => [:show, :menu]

  def index
  end

  def show
    @diabetics = current_account.diabetics
    render  'accounts/show',
            :locals => {
              account: current_account,
              diabetics: @diabetics,
              menu_options: format_menu(@diabetics, current_account)
            }
  end

  def new
    render  :partial => 'accounts/new',
            :locals => {
              account: Account.new
            }
  end

  def create
    account = Account.new(params['account'])
    if account.save
      ok = true
      login account
      path = new_account_diabetic_path(account.id)
    else
      path = new_account_path
    end
    render_json(!!ok, path, account.errors.full_messages)
  end

  def edit
    render  :partial => 'accounts/edit',
            :locals => {
              account: current_account
            }
  end

  def change_password
    if current_account.authenticate(params[:password])
      current_account.password = params[:new_password]
      current_account.password_confirmation = params[:password_confirmation]
      if current_account.save
        ok = true
        path = account_path(current_account)
      end
    end
    render_json(!!ok, path, current_account.errors.full_messages)
  end

  def update
    if current_account.authenticate(params[:account][:password])
      ok = true
      current_account.update_attributes(params[:account])
      path = dashboard_path
    else
      notice = ['Invalid Password']
      path = edit_account_path(current_account)
    end
    render_json(!!ok, path, notice)
  end

  private

  def redirect_unless_authorized
    redirect_to root_path unless current_account.id == params[:id].to_i
  end
end
