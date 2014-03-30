module AuthenticationHelper
  def current_account
    @account ||= Account.find(session[:account_id]) if session[:account_id]
  end

  def logged_in?
    !!current_account
  end

  def login account
    session[:account_id] = account.id
  end
end
