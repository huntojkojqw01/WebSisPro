class UsersController < ApplicationController
	before_action :logged_in_user,  only: [:edit, :update,:index,:destroy] 
	before_action :correct_user, only: [:edit, :update]
	def index		
		@users=User.all
	end
	def show
		@user=User.find_by_id(params[:id])
	end
	def new
		@user=User.new
	end
	def create		
		@user=User.new(user_params)		
		if @user.save
			redirect_to @user
		else
			render 'new'
		end
	end
	def edit
	    @user = User.find_by_id(params[:id])
	end
	def update
		@user = User.find_by_id(params[:id])
	    if @user.update_attributes(user_params)	      
	      redirect_to @user
	    else
	      render 'edit'
	    end
	end
	def destroy
		user=User.find_by_id(params[:id])
		user.destroy if user
		redirect_to users_path
	end
	private
	def user_params
		params.require(:user).permit(:name,:password,:password_confirmation)
	end
	
end
