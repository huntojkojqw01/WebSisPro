class LophocsController < ApplicationController
	include ApplicationHelper
	before_action :logged_in_user, except: [:index]
	before_action :is_admin, except: [:index]
	before_action :set_x, only: [:edit,:update,:destroy]
	def index
		@lophocs=Lophoc.includes(hocphan: :khoavien).includes(:hocki)
		.left_outer_joins(:dangkilophocs)
		.group(:id)
		.select("lophocs.*","count(dangkilophocs.id) as dadangki")
	end	
	def new
		@lophoc = Lophoc.new
	end
	def show
		@lophoc=Lophoc.joins(:hocphan,:giaovien,:hocki).left_outer_joins(:dangkilophocs)				
				.group(:id,:malophoc,:mahocphan,:tenhocphan,:tengiaovien,:mahocki)
				.select("lophocs.*","mahocphan","tenhocphan","tengiaovien","mahocki","count(dangkilophocs.id) as dadangki")
				.find_by_id(params[:id])
		unless @lophoc
			flash[:info]="見付からない"	
			redirect_to root_url
		else
			@sinhviens=Sinhvien.joins(:lopsinhvien,dangkilophocs: :lophoc).where("dangkilophocs.lophoc_id=?",@lophoc.id)
				.select("sinhviens.*","tenlopsinhvien")
				.paginate(page: params[:page],:per_page=>20)	
		end										
	end
	def edit		
	end
	def destroy
		if params[:ids]
			params[:ids].each do |lophoc_id|
				lophoc=Lophoc.find_by_id(lophoc_id)
				if lophoc
					lophoc.destroy					
				end
			end			        
			respond_to do |f|
				f.json {render json: {destroy_success: 'success'}}				
			end
		else			
			@lophoc.destroy		
			flash[:info]= '削除しました'
			redirect_to lophocs_path
		end
	end
	def update
		if @lophoc.update(x_params)
		    flash[:info]='更新しました'
		    redirect_to @lophoc
		else		    	
		    render 'edit'
		end			    
  	end
	def create
		@lophoc=Lophoc.new(x_params)
		if @lophoc.save
		    flash[:success]= '追加しました'
		    redirect_to @lophoc
		else		        
		    render 'new'
		end		
    end
    def import
	    r=Lophoc.import(params[:file])
	    if r[0]
	      	flash[:success]= "File is imported(#{r[1]-1} record)."	      
	    else
			flash[:danger]= "エラ➖ #{r[1]}: #{r[2]}."			
	    end
	    redirect_to search_lophocs_path
	end	
	private
	def set_x
		unless params[:ids] || @lophoc=Lophoc.find_by_id(params[:id])
			flash[:info]="見付からない"	
			redirect_to root_url	
		end		
	end
	def x_params
	    pars=params.require(:lophoc).permit(:malophoc,:thoigian,:diadiem,:giaovien_id,:hocphan_id,:hocki_id,:maxdangki)
		pars[:thoigian]=convertTime(pars[:thoigian])
		pars
	end	
	
end
