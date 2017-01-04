class LophocsController < ApplicationController
	include ApplicationHelper
	before_action :logged_in_user, except: [:index]
	before_action :is_admin, except: [:index]
	before_action :set_x, only: [:edit,:update,:show,:destroy]
	def index
		@selected=params
		@hockis=Hocki.order(:mahocki)
		@khoaviens=Khoavien.order(:tenkhoavien)		
		if @selected[:khoavien_id]&&@selected[:khoavien_id]!=""
			if @selected[:hocki_id]&&@selected[:hocki_id]!=""
				@lophocs=Khoavien.find_by_id(@selected[:khoavien_id]).lophocs.where("hocki_id = ? and malophoc like ? and mahocphan like ?",@selected[:hocki_id],"%#{@selected[:malophoc]}%","%#{@selected[:mahocphan]}%").paginate(page: params[:page],:per_page=>20)
			else
				@lophocs=Khoavien.find_by_id(@selected[:khoavien_id]).lophocs.where("malophoc like ? and mahocphan like ?","%#{@selected[:malophoc]}%","%#{@selected[:mahocphan]}%").paginate(page: params[:page],:per_page=>20)
			end
		else
			if @selected[:hocki_id]&&@selected[:hocki_id]!=""
				@lophocs=Lophoc.joins(:hocphan).where("hocki_id = ? and malophoc like ? and mahocphan like ?",@selected[:hocki_id],"%#{@selected[:malophoc]}%","%#{@selected[:mahocphan]}%").paginate(page: params[:page],:per_page=>20)
			else
				@lophocs=Lophoc.joins(:hocphan).where("malophoc like ? and mahocphan like ?","%#{@selected[:malophoc]}%","%#{@selected[:mahocphan]}%").paginate(page: params[:page],:per_page=>20)
			end		
		end		
			
		@lhs = Lophoc.order :malophoc
        respond_to do |format|
          format.html
          format.csv { send_data @lhs.as_csv }
      	end
	end	
	def new
		@lophoc = Lophoc.new
	end
	def show		
		@dangkilophocs=@lophoc.dangkilophocs.paginate(page: params[:page],:per_page=>20)						
	end
	def edit
		
	end
	def destroy
		@lophoc.destroy
		flash[:info]= 'Đã xóa .'
		redirect_to lophocs_path
		end
	def update
		par=x_params
		lophoc=Lophoc.new(par)
		r=lophocOk(lophoc)
		if r.first			
		    if @lophoc.update(par)
		    	flash[:info]='Đã cập nhật .'
		    	redirect_to @lophoc
		    else
		    	
		    	render 'edit'
		    end
	    else
			flash[:danger]=r.last
		    redirect_to(:back)
		end
  	end
	def create
		@lophoc=Lophoc.new(x_params)
		r=lophocOk(@lophoc)
		if r.first
			if @lophoc.save
		      	flash[:success]= 'Tạo mới thành công .'
		        redirect_to @lophoc
		    else
		        
		        render 'new'
		    end
		else
			flash[:danger]=r.last
		    redirect_to(:back)
		end
    end
    def import
	    begin
	    	count=Lophoc.import(params[:file])
	    	flash[:success]= "File is imported(#{count} records)."	      
	    rescue
			flash[:danger]= "Invalid CSV file format."			
	    end
	    redirect_to lophocs_path
	end	
	private
	def set_x
		@lophoc=Lophoc.find_by_id(params[:id])
		if @lophoc			
		else
			flash[:info]="Khong tim thay lop hoc nay."
			redirect_to root_url
		end	
	end
	def x_params
	    pars=params.require(:lophoc).permit(:malophoc,:thoigian,:diadiem,:giaovien_id,:hocphan_id,:hocki_id,:maxdangki)
		pars[:thoigian]=convertTime(pars[:thoigian])
		pars
	end	
	
end
