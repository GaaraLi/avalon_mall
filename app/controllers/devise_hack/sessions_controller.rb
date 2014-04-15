class DeviseHack::SessionsController < Devise::SessionsController
	def new
		redirect_to "http://ixiangche.com/customers/login"
	end
end