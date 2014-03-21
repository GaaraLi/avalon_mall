class DeviseHack::SessionsController < Devise::SessionsController
	def new
		redirect_to "http://test.ixiangche.com/customers/login"
	end
end