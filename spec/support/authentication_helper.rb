module AuthenticationHelper

	def stub_current_account(account)
		ApplicationController.any_instance.stub(:current_account){ account }
	end

end