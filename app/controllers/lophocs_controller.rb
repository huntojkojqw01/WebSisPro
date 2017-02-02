class LophocsController < ApplicationController
	include ApplicationHelper
	before_action :logged_in_user, except: [:index]
	before_action :is_admin, except: [:index,:search]
	before_action :set_x, only: [:edit,:update,:destroy]
	def index
		if params[:khoavien_id]&&params[:khoavien_id]!=""
			if params[:hocki_id]&&params[:hocki_id]!=""
				@lophocs=Lophoc.joins(hocphan: :khoavien).left_outer_joins(:dangkilophocs)
				.where("khoavien_id=? and hocki_id = ? and malophoc like ? and mahocphan like ?",params[:khoavien_id],params[:hocki_id],"%#{params[:malophoc]}%","%#{params[:mahocphan]}%")
				.group(:id,:malophoc,:mahocphan,:tenhocphan)
				.select("lophocs.*","mahocphan","tenhocphan","count(dangkilophocs.id) as dadangki")
				.paginate(page: params[:page],:per_page=>20)
			else
				@lophocs=Lophoc.joins(hocphan: :khoavien).left_outer_joins(:dangkilophocs)
				.where("khoavien_id=? and malophoc like ? and mahocphan like ?",params[:khoavien_id],"%#{params[:malophoc]}%","%#{params[:mahocphan]}%")
				.group(:id,:malophoc,:mahocphan,:tenhocphan)
				.select("lophocs.*","mahocphan","tenhocphan","count(dangkilophocs.id) as dadangki")
				.paginate(page: params[:page],:per_page=>20)
			end
		else
			if params[:hocki_id]&&params[:hocki_id]!=""
				@lophocs=Lophoc.joins(:hocphan).left_outer_joins(:dangkilophocs)
				.where("hocki_id = ? and malophoc like ? and mahocphan like ?",params[:hocki_id],"%#{params[:malophoc]}%","%#{params[:mahocphan]}%")
				.group(:id,:malophoc,:mahocphan,:tenhocphan)
				.select("lophocs.*","mahocphan","tenhocphan","count(dangkilophocs.id) as dadangki")
				.paginate(page: params[:page],:per_page=>20)
			else
				@lophocs=Lophoc.joins(:hocphan).left_outer_joins(:dangkilophocs)
				.where("malophoc like ? and mahocphan like ?","%#{params[:malophoc]}%","%#{params[:mahocphan]}%")
				.group(:id,:malophoc,:mahocphan,:tenhocphan)
				.select("lophocs.*","mahocphan","tenhocphan","count(dangkilophocs.id) as dadangki")
				.paginate(page: params[:page],:per_page=>20)
			end		
		end		
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
			flash[:info]="Không tìm thấy dữ liệu"	
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
		@lophoc.destroy
		flash[:info]= 'Đã xóa .'
		redirect_to search_lophocs_path
		end
	def update
		if @lophoc.update(x_params)
		    flash[:info]='Đã cập nhật .'
		    redirect_to @lophoc
		else		    	
		    render 'edit'
		end			    
  	end
	def create
		@lophoc=Lophoc.new(x_params)
		if @lophoc.save
		    flash[:success]= 'Tạo mới thành công .'
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
			flash[:danger]= "Lỗi tại dòng thứ #{r[1]}: #{r[2]}."			
	    end
	    redirect_to search_lophocs_path
	end	
	private
	def set_x
		unless @lophoc=Lophoc.find_by_id(params[:id])
			flash[:info]="Không tìm thấy dữ liệu"	
			redirect_to root_url	
		end		
	end
	def x_params
	    pars=params.require(:lophoc).permit(:malophoc,:thoigian,:diadiem,:giaovien_id,:hocphan_id,:hocki_id,:maxdangki)
		pars[:thoigian]=convertTime(pars[:thoigian])
		pars
	end	
	
end
