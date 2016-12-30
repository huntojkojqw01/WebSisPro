class LophocsController < ApplicationController
	before_action :set_x, only: [:edit,:update,:show,:destroy]
	def index
		@hockis=Hocki.order(mahocki: :asc)
		@khoaviens=Khoavien.all
		@selected=params
		if @selected[:khoavien_id]&&@selected[:khoavien_id]!=""
			if @selected[:hocki_id]&&@selected[:hocki_id]!=""
				@lophocs=Khoavien.find_by(id:@selected[:khoavien_id]).lophocs.where("hocki_id = ? and malophoc like ? and mahocphan like ?",@selected[:hocki_id],"%#{@selected[:malophoc]}%","%#{@selected[:mahocphan]}%")
			else
				@lophocs=Khoavien.find_by(id:@selected[:khoavien_id]).lophocs.left_outer_joins(:hocphan).where("malophoc like ? and mahocphan like ?","%#{@selected[:malophoc]}%","%#{@selected[:mahocphan]}%")
			end
		else
			if @selected[:hocki_id]&&@selected[:hocki_id]!=""
				@lophocs=Hocki.find_by(id:@selected[:hocki_id]).lophocs.left_outer_joins(:hocphan).where("malophoc like ? and mahocphan like ?","%#{@selected[:malophoc]}%","%#{@selected[:mahocphan]}%")
			else
				@lophocs=Lophoc.left_outer_joins(:hocphan).where("malophoc like ? and mahocphan like ?","%#{@selected[:malophoc]}%","%#{@selected[:mahocphan]}%")
			end		
		end		
		@lophocs=@lophocs.paginate(page: params[:page],:per_page=>20)		
		@lhs = @lophocs.order :malophoc
        respond_to do |format|
          format.html
          format.csv { send_data @lhs.as_csv }
      	end
	end	
	def new
		@lophoc = Lophoc.new
	end
	def show		
		@sinhviens=@lophoc.sinhviens.paginate(page: params[:page],:per_page=>20)						
	end
	def edit
		
	end
	def destroy
		@lophoc.destroy
		flash[:info]= 'Đã xóa .'
		redirect_to lophocs_path
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
	    params.require(:lophoc).permit(:malophoc,:thoigian,:diadiem,:giaovien_id,:hocphan_id,:hocki_id,:maxdangki)
	end	
	
end
