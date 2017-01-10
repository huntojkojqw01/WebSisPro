class LophocsController < ApplicationController
	include ApplicationHelper
	before_action :logged_in_user, except: [:index]
	before_action :is_admin, except: [:index]
	before_action :set_x, only: [:edit,:update,:destroy]
	def index
		@selected=params.permit(:khoavien_id,:hocki_id,:mahocphan,:malophoc)
		@hockis=Hocki.all
		@khoaviens=Khoavien.all
		if @selected[:khoavien_id]&&@selected[:khoavien_id]!=""
			if @selected[:hocki_id]&&@selected[:hocki_id]!=""
				@lophocs=Lophoc.joins({hocphan: :khoavien},:dangkilophocs)
				.where("khoavien_id=? and hocki_id = ? and malophoc like ? and mahocphan like ?",@selected[:khoavien_id],@selected[:hocki_id],"%#{@selected[:malophoc]}%","%#{@selected[:mahocphan]}%")
				.group(:id,:malophoc,:mahocphan,:tenhocphan)
				.select("lophocs.*","mahocphan","tenhocphan","count(dangkilophocs.id) as dadangki")
				.paginate(page: params[:page],:per_page=>20)
			else
				@lophocs=Lophoc.joins({hocphan: :khoavien},:dangkilophocs)
				.where("khoavien_id=? and malophoc like ? and mahocphan like ?",@selected[:khoavien_id],"%#{@selected[:malophoc]}%","%#{@selected[:mahocphan]}%")
				.group(:id,:malophoc,:mahocphan,:tenhocphan)
				.select("lophocs.*","mahocphan","tenhocphan","count(dangkilophocs.id) as dadangki")
				.paginate(page: params[:page],:per_page=>20)
			end
		else
			if @selected[:hocki_id]&&@selected[:hocki_id]!=""
				@lophocs=Lophoc.joins(:hocphan,:dangkilophocs)
				.where("hocki_id = ? and malophoc like ? and mahocphan like ?",@selected[:hocki_id],"%#{@selected[:malophoc]}%","%#{@selected[:mahocphan]}%")
				.group(:id,:malophoc,:mahocphan,:tenhocphan)
				.select("lophocs.*","mahocphan","tenhocphan","count(dangkilophocs.id) as dadangki")
				.paginate(page: params[:page],:per_page=>20)
			else
				@lophocs=Lophoc.joins(:hocphan,:dangkilophocs)
				.where("malophoc like ? and mahocphan like ?","%#{@selected[:malophoc]}%","%#{@selected[:mahocphan]}%")
				.group(:id,:malophoc,:mahocphan,:tenhocphan)
				.select("lophocs.*","mahocphan","tenhocphan","count(dangkilophocs.id) as dadangki")
				.paginate(page: params[:page],:per_page=>20)
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
		@lophoc=Lophoc.joins(:hocphan,:giaovien,:hocki,:dangkilophocs)				
				.group(:id,:malophoc,:mahocphan,:tenhocphan,:tengiaovien,:mahocki)
				.select("lophocs.*","mahocphan","tenhocphan","tengiaovien","mahocki","count(dangkilophocs.id) as dadangki")
				.find_by_id(params[:id])		
		@sinhviens=@lophoc.sinhviens.joins(:lopsinhvien)
			.select("sinhviens.*","tenlopsinhvien")
			.paginate(page: params[:page],:per_page=>20)						
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
	    r=Lophoc.import(params[:file])
	    if r[0]
	      	flash[:success]= "File is imported(#{r[1]-1} record)."	      
	    else
			flash[:danger]= "Lỗi tại dòng thứ #{r[1]}: #{r[2]}."			
	    end
	    redirect_to lophocs_path
	end	
	private
	def set_x
		@lophoc=Lophoc.find_by_id(params[:id])		
	end
	def x_params
	    pars=params.require(:lophoc).permit(:malophoc,:thoigian,:diadiem,:giaovien_id,:hocphan_id,:hocki_id,:maxdangki)
		pars[:thoigian]=convertTime(pars[:thoigian])
		pars
	end	
	
end
