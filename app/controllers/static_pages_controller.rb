class StaticPagesController < ApplicationController
	def index
	end
	def my_data
		respond_to do |format|
			format.html {render 'my_data'}
			format.js
		end

	end
end
