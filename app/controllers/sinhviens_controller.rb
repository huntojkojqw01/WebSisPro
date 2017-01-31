class SinhviensController < ApplicationController
	include ApplicationHelper
	before_action :logged_in_user, except: [:index,:svdkh]
	before_action :is_admin, only: [:edit,:update,:new,:create,:destroy]	
	before_action :is_sinhvien, only: [:dangkilophoc,:dangkihocphan,:thoikhoabieu,:bangdiem,:chuongtrinhdaotao]
	before_action :chinh_chu , only: [:show]
	before_action :set_x, only: [:edit,:update,:destroy]
	before_action :xx_params ,only: :duyet
	def index
		if params[:khoavien_id]&&params[:khoavien_id]!=""
			if params[:khoahoc]&&params[:khoahoc]!=""
				@lopsinhviens=Lopsinhvien.where("khoavien_id=? and khoahoc=?", params[:khoavien_id], params[:khoahoc] ) 
				if params[:lopsinhvien_id]&&params[:lopsinhvien_id]!=""					
					@sinhviens=Sinhvien.joins(:lopsinhvien).select("sinhviens.*","tenlopsinhvien")
					.where("lopsinhvien_id=? and tensinhvien like ? and masinhvien like ?",params[:lopsinhvien_id],"%#{params[:tensinhvien]}%","%#{params[:masinhvien]}%")
					.paginate(page: params[:page],:per_page=>20)
				else
					@sinhviens=Sinhvien.joins(:lopsinhvien).select("sinhviens.*","tenlopsinhvien")
					.where("khoavien_id=? and khoahoc=? and tensinhvien like ? and masinhvien like ?",params[:khoavien_id],params[:khoahoc],"%#{params[:tensinhvien]}%","%#{params[:masinhvien]}%")
					.paginate(page: params[:page],:per_page=>20)
				end
			else
				@lopsinhviens=Lopsinhvien.where("khoavien_id=? ",params[:khoavien_id])				
				if params[:lopsinhvien_id]&&params[:lopsinhvien_id]!=""					
					@sinhviens=Sinhvien.joins(:lopsinhvien).select("sinhviens.*","tenlopsinhvien")
					.where("lopsinhvien_id=? and tensinhvien like ? and masinhvien like ? ",params[:lopsinhvien_id],"%#{params[:tensinhvien]}%","%#{params[:masinhvien]}%")
					.paginate(page: params[:page],:per_page=>20)
				else					
					@sinhviens=Sinhvien.joins(:lopsinhvien).select("sinhviens.*","tenlopsinhvien")
					.where("khoavien_id=? and tensinhvien like ? and masinhvien like ?",params[:khoavien_id],"%#{params[:tensinhvien]}%","%#{params[:masinhvien]}%")
					.paginate(page: params[:page],:per_page=>4)
				end
			end						
		else			
			if params[:khoahoc]&&params[:khoahoc]!=""
				@lopsinhviens=Lopsinhvien.where("khoahoc=?",params[:khoahoc])				 
				if params[:lopsinhvien_id]&&params[:lopsinhvien_id]!=""					
					@sinhviens=Sinhvien.joins(:lopsinhvien).select("sinhviens.*","tenlopsinhvien")
					.where("lopsinhvien_id=? and tensinhvien like ? and masinhvien like ? ",params[:lopsinhvien_id],"%#{params[:tensinhvien]}%","%#{params[:masinhvien]}%")
					.paginate(page: params[:page],:per_page=>20)
				else					
					@sinhviens=Sinhvien.joins(:lopsinhvien).select("sinhviens.*","tenlopsinhvien")
					.where("khoahoc=? and tensinhvien like ? and masinhvien like ?",params[:khoahoc],"%#{params[:tensinhvien]}%","%#{params[:masinhvien]}%")
					.paginate(page: params[:page],:per_page=>20)
				end
			else
				@lopsinhviens=Lopsinhvien.order :tenlopsinhvien 
				if params[:lopsinhvien_id]&&params[:lopsinhvien_id]!=""					
					@sinhviens=Sinhvien.joins(:lopsinhvien).select("sinhviens.*","tenlopsinhvien")
					.where("lopsinhvien_id=? and tensinhvien like ? and masinhvien like ? ",params[:lopsinhvien_id],"%#{params[:tensinhvien]}%","%#{params[:masinhvien]}%")
					.paginate(page: params[:page],:per_page=>20)
				else										
					@sinhviens=Sinhvien.joins(:lopsinhvien).select("sinhviens.*","tenlopsinhvien")
					.where("tensinhvien like ? and masinhvien like ?","%#{params[:tensinhvien]}%","%#{params[:masinhvien]}%")
					.paginate(page: params[:page],:per_page=>20)										
				end
			end	
		end		
	end	
	def new
		@sinhvien = Sinhvien.new
	end
	def show		
		unless @sinhvien=Sinhvien.joins(:lopsinhvien).select("sinhviens.*","tenlopsinhvien").find_by_id(params[:id])			
			flash[:danger]="Không tìm thấy sinh viên"
			redirect_to search_sinhviens_path
		end
	end
	def edit		
	end
	def destroy
		user=@sinhvien.user
		@sinhvien.destroy
		if user!=nil
		    user.destroy
		end
		flash[:info]= 'Đã xóa .'
		redirect_to search_sinhviens_path
	end
	def update
	    if @sinhvien.update(update_params)
	      	flash[:info]='Đã cập nhật .'
	        redirect_to @sinhvien
	    else
	       	render 'edit'
	    end
  	end
	def create
		@sinhvien=Sinhvien.new(x_params)
		if @sinhvien.save
			user=User.create!(name:@sinhvien[:masinhvien],password:"123456",password_confirmation:"123456",loai:"sv")
			flash[:success]= 'Tạo mới thành công .'
			redirect_to @sinhvien
		else
			render 'new'
		end		    
	end
	def import
	    r=Sinhvien.import(params[:file])
	    if r[0]
	      	flash[:success]= "File is imported(#{r[1]-1} record)."	      
	    else
			flash[:danger]= "Lỗi tại dòng thứ #{r[1]}: #{r[2]}."			
	    end
	    redirect_to sinhviens_path
	end
	def thoikhoabieu
		params=params.permit(:hocki_id)
		if params[:hocki_id]
			@hocki=Hocki.find_by_id(params[:hocki_id])
			@lophocs=Lophoc.joins(:hocphan,:dangkilophocs).select("lophocs.*","hocphans.*","hesohocphi")
			.where("hocki_id=? and sinhvien_id=?",params[:hocki_id],@current_sinhvien.id)		
		end		
	end
	def bangdiem
		@lophocs=Lophoc.joins(:hocphan,:hocki,:dangkilophocs)
		.where("sinhvien_id=?",@current_sinhvien.id)
		.select("lophocs.*","mahocki","diemquatrinh","diemthi","diemso","diemchu","mahocphan","tenhocphan","tinchi")
		.reorder(:hocki_id).paginate(page: params[:page],:per_page=>10)
	end
	def chuongtrinhdaotao
		params=params.permit(:sort_by)			
		case params[:sort_by]
		when "mahocphan"
			@hocphans=Hocphan.joins(:chuongtrinhdaotaos)
			.where("lopsinhvien_id=?",@current_sinhvien.lopsinhvien_id).select("hocphans.*","hocki")
			.order(:mahocphan).paginate(page: params[:page],:per_page=>20)
		when "tenhocphan"					
			@hocphans=Hocphan.joins(:chuongtrinhdaotaos)
			.where("lopsinhvien_id=?",@current_sinhvien.lopsinhvien_id).select("hocphans.*","hocki")
			.order(:tenhocphan).paginate(page: params[:page],:per_page=>20)
		when "tinchi"
			@hocphans=Hocphan.joins(:chuongtrinhdaotaos)
			.where("lopsinhvien_id=?",@current_sinhvien.lopsinhvien_id).select("hocphans.*","hocki")
			.order(:tinchi).paginate(page: params[:page],:per_page=>20)
		else
			@hocphans=Hocphan.joins(:chuongtrinhdaotaos)
			.where("lopsinhvien_id=?",@current_sinhvien.lopsinhvien_id).select("hocphans.*","hocki")
			.order("hocki").paginate(page: params[:page],:per_page=>20)
		end
	end
	def dangkilophoc
		params=params.permit(:khoavien_id,:malophoc,:mahocphan)
		if mo_dangki_lophoc?		
			@khoaviens=Khoavien.all		
			if params[:khoavien_id]&&params[:khoavien_id]!=""
				@lophocs=@hocki_modangkilophoc.lophocs.left_outer_joins(:hocphan).where("khoavien_id = ? and malophoc like ? and mahocphan like ?",params[:khoavien_id],"%#{params[:malophoc]}%","%#{params[:mahocphan]}%").paginate(page: params[:page],:per_page=>20)
			else
				@lophocs=@hocki_modangkilophoc.lophocs.left_outer_joins(:hocphan).where("malophoc like ? and mahocphan like ?","%#{params[:malophoc]}%","%#{params[:mahocphan]}%").paginate(page: params[:page],:per_page=>20)
			end					
			@registeds=@@current_sinhvien.lophocs.where("hocki_id=?",@hocki_modangkilophoc.id)
		else
			flash[:info]="Không có học kì nào mở đăng kí"
			redirect_to root_url
		end
	end
	def dangkihocphan
		params=params.permit(:khoavien_id,:tenhocphan,:mahocphan)
		if mo_dangki_hocphan?		
			@khoaviens=Khoavien.all		
			if params[:khoavien_id]&&params[:khoavien_id]!=""
				@hocphans=@hocki_modangkihocphan.hocphans
				.where("khoavien_id = ? and tenhocphan like ? and mahocphan like ?",params[:khoavien_id],"%#{params[:tenhocphan]}%","%#{params[:mahocphan]}%")
				.reorder(:mahocphan)
				.distinct.paginate(page: params[:page],:per_page=>20)
			else
				@hocphans=@hocki_modangkihocphan.hocphans
				.where("tenhocphan like ? and mahocphan like ?","%#{params[:tenhocphan]}%","%#{params[:mahocphan]}%")
				.reorder(:mahocphan)
				.distinct.paginate(page: params[:page],:per_page=>20)
			end					
			@registeds=@@current_sinhvien.hocphans.where("hocki_id=?",@hocki_modangkihocphan.id)
		else
			flash[:info]="Không có học kì nào mở đăng kí"
			redirect_to root_url
		end
	end
	def svdkh
		params=params.permit(:masinhvien)
		if params[:masinhvien]
			if current_hocki		
				@hocki=Hocki.find_by_id(current_hocki.id)
			else
				@hocki=Hocki.find_by_id(last_hocki.id)
			end
			if @hocki 
				@sinhvien=Sinhvien.find_by(masinhvien: params[:masinhvien])
				if @sinhvien
					@lophocs=Lophoc.joins(:hocphan,:dangkilophocs).select("lophocs.*","hocphans.*","hesohocphi")
							.where("hocki_id=? and sinhvien_id=?",@hocki.id,@sinhvien.id)
				else
					flash[:info]="Không tìm thấy sinh viên nào phù hợp"
				end			
			else
				flash[:info]="Không có học kì nào phù hợp"					
			end
		end
	end
	def duyet
        @mons=[]
        if @hocphan_ids
            @hocphan_ids.each do |x|                            
            	@mons<<Hocphan.find_by_id(x)
            end                     	
            @mang_ket_qua=[]
           	@danh_sach_lop=[]
            tim_thoi_khoa_bieu(0)                                            
        end
    end
	private
	def set_x
		unless @sinhvien=Sinhvien.find_by_id(params[:id])
			flash[:info]="Không tìm thấy dữ liệu"	
			redirect_to root_url	
		end
	end
	def update_params
	      params.require(:sinhvien).permit(:tensinhvien,:ngaysinh,:email,:trangthai,:lopsinhvien_id)
	end	
	def x_params
	      params.require(:sinhvien).permit(:masinhvien,:tensinhvien,:ngaysinh,:email,:trangthai,:lopsinhvien_id)
	end			
	
	def xx_params
            	@hocphan_ids=params[:list] ? params[:list].collect {|x| x.to_i} : nil
                  @tkb=0
                  if params[:so_tiets]!=nil
                    params[:so_tiets].each do |i|
                        @tkb|=(1<<i.to_i)
                    end
                  end


            end
	def check_tkb(ds_lop,tkb)
                ds_lop.each do |lop|
                  if tkb&lop.thoigian==0
                    tkb|=lop.thoigian
                  else
                    return false
                  end                           
                end
                return true
    end
    def  tim_thoi_khoa_bieu(mon_hien_tai)
                lhs=@mons[mon_hien_tai].lophocs.where("hocki_id=?",current_hocki.id)
                lhs.each do |lop|
                  @danh_sach_lop<<lop
                  if check_tkb(@danh_sach_lop,@tkb)  
                        if @danh_sach_lop.count==@mons.count
                                              @mang_ket_qua<<Array.new(@danh_sach_lop)
                                              @danh_sach_lop.pop
                        else    
                                  tim_thoi_khoa_bieu(mon_hien_tai+1)
                                  @danh_sach_lop.pop
                         end
                                
                    else
                          @danh_sach_lop.pop        
                  end
                end# lhs.each do |lop|                  
    end#end tim_thoi_khoa_bieu
    def chinh_chu
    	if sinhvien?  
        unless @current_sinhvien.id==params[:id].to_i
          flash[:danger]="Bạn không phải chính chủ !"
          redirect_to(root_url) 
        end
        end
    end
end
