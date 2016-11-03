class SessionsController < ApplicationController
	def new

	end
	def create
		user=User.find_by(name: params[:sison][:name])
		if user&&user.authenticate(params[:sison][:password])
			log_in user
			params[:sison][:remember_me]==1 ? remember(user) : forget(user)
			redirect_back_or user
		else
			render 'new'
		end
	end
	def destroy
		log_out if logged_in?
    	redirect_to root_url	
	end	
end
