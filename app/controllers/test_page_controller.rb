class TestPageController < ApplicationController
	def home		
	end
	def sieu		
		if params[:chim]
			@hocki=Hocki.first
		else 
			@hocki=Hocki.last
		end		
	end
end
