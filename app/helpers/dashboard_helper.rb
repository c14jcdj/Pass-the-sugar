module DashboardHelper
  def format_menu(diabetics, account)
    result = ['Pick a User or account']
    result += diabetics.map {|diabetic| "Diabetic: #{diabetic.name} -- #{diabetic.id} "}
    result << "Account: #{current_account.username}"
    result
  end
end
