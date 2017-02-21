class SinhviensController < ApplicationController
	include ApplicationHelper
	before_action :logged_in_user, except: [:index,:search,:svdkh]
	before_action :is_admin, only: [:edit,:update,:new,:create,:destroy]	
	before_action :is_sinhvien, only: [:dangkilophoc,:thoikhoabieu,:bangdiem]
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
			flash[:danger]="見付からない"
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
		flash[:info]= '削除しました'
		redirect_to search_sinhviens_path
	end
	def update
	    if @sinhvien.update(update_params)
	      	flash[:info]='更新しました'
	        redirect_to @sinhvien
	    else
	       	render 'edit'
	    end
  	end
	def create
		@sinhvien=Sinhvien.new(x_params)
		user=User.create(name:@sinhvien[:masinhvien],password:"123456",password_confirmation:"123456",loai:"sv")
		if user.id
			@sinhvien[:user_id]=user.id			
			if @sinhvien.save				
				flash[:success]= '追加しました'
				redirect_to @sinhvien
			else
				user.destroy
				render 'new'
			end
		else
			flash[:danger]= 'アカウントを作成できない'
			render 'new'
		end		    
	end
	def search
		@khoahocs=Lopsinhvien.reorder(:khoahoc).select("khoahoc").distinct
	end
	def import
	    r=Sinhvien.import(params[:file])
	    if r[0]
	      	flash[:success]= "File is imported(#{r[1]-1} record)."	      
	    else
			flash[:danger]= "エラ➖ #{r[1]}: #{r[2]}."			
	    end
	    redirect_to sinhviens_path
	end
	def thoikhoabieu		
		if params[:hocki_id]
			@hocki=Hocki.find_by_id(params[:hocki_id])
			@lophocs=Lophoc.joins(:hocphan,:dangkilophocs)
					.select("lophocs.*","mahocphan","tenhocphan","tinchi","tinchihocphi","hesohocphi","tinchihocphi*hesohocphi as tongphi")
					.where("hocki_id=? and sinhvien_id=?",params[:hocki_id],@current_sinhvien.id)		
		end		
	end
	def bangdiem		
		@alllophocs=Lophoc.joins(:hocphan,:hocki,:dangkilophocs)
				.where("sinhvien_id=? and diemchu!=?",@current_sinhvien.id,"")
				.select("lophocs.*","mahocki","diemquatrinh","diemthi","diemso","diemchu","mahocphan","tenhocphan","tinchi")
				.reorder(:hocki_id)
		@lophocs=@alllophocs.paginate(page: params[:page],:per_page=>15)		
		@results={}
		hocphans={}
		@alllophocs.each do |lh|
			if @results.key? lh.mahocki
				@results["#{lh.mahocki}"][:tcdkKI]+=lh.tinchi
				@results["#{lh.mahocki}"][:tcqKI]+=lh.diemso>0 ? lh.tinchi : 0
				@results["#{lh.mahocki}"][:diemki]+=lh.diemso*lh.tinchi
				if hocphans.key? lh.mahocphan
					diemcu=	hocphans["#{lh.mahocphan}"][:diemcu]			
					@results["#{lh.mahocki}"][:tcdkKI_thucte]+=0
					@results["#{lh.mahocki}"][:tcqKI_thucte]+= diemcu <=0 ? lh.tinchi : 0
					@results["#{lh.mahocki}"][:diemki_thucte]+= lh.diemso>diemcu ? (lh.diemso-diemcu)*lh.tinchi : 0
					hocphans["#{lh.mahocphan}"][:diemcu]=lh.diemso if diemcu<lh.diemso
				else
					@results["#{lh.mahocki}"][:tcdkKI_thucte]+=lh.tinchi
					@results["#{lh.mahocki}"][:tcqKI_thucte]+= lh.diemso>0 ? lh.tinchi : 0
					@results["#{lh.mahocki}"][:diemki_thucte]+= lh.diemso*lh.tinchi
					hocphans["#{lh.mahocphan}"]={diemcu: lh.diemso}
				end				
			else
				@results["#{lh.mahocki}"]={
					tcdkKI: lh.tinchi,
					tcqKI: lh.diemso>0 ? lh.tinchi : 0,
					diemki: lh.diemso*lh.tinchi,								
				}
				if hocphans.key? lh.mahocphan
					diemcu=	hocphans["#{lh.mahocphan}"][:diemcu]			
					@results["#{lh.mahocki}"][:tcdkKI_thucte]=0
					@results["#{lh.mahocki}"][:tcqKI_thucte]= diemcu <=0 ? lh.tinchi : 0
					@results["#{lh.mahocki}"][:diemki_thucte]= lh.diemso>diemcu ? (lh.diemso-diemcu)*lh.tinchi : 0
					hocphans["#{lh.mahocphan}"][:diemcu]=lh.diemso if diemcu<lh.diemso
				else
					@results["#{lh.mahocki}"][:tcdkKI_thucte]=lh.tinchi
					@results["#{lh.mahocki}"][:tcqKI_thucte]= lh.diemso>0 ? lh.tinchi : 0
					@results["#{lh.mahocki}"][:diemki_thucte]= lh.diemso*lh.tinchi
					hocphans["#{lh.mahocphan}"]={diemcu: lh.diemso}
				end					
			end							
		end
		tongTCdangki=tongTCqua=tongDiem=0
		@results.each do |key,val|
			tongDiem+=val[:diemki_thucte]
			tongTCdangki+=val[:tcdkKI_thucte]
			tongTCqua+=val[:tcqKI_thucte]
			val[:gpa]=(val[:diemki]/val[:tcdkKI]).round(2)
			val[:cpa]=(tongDiem/tongTCdangki).round(2)
			val[:tcdkKH]=tongTCdangki
			val[:tcqKH]=tongTCqua
		end
	end	
	def svdkh		
		if params[:masinhvien]
			if current_hocki		
				@hocki=Hocki.find_by_id(current_hocki.id)
			else
				@hocki=Hocki.find_by_id(last_hocki.id)
			end
			if @hocki 
				@sinhvien=Sinhvien.find_by(masinhvien: params[:masinhvien])
				if @sinhvien
					@lophocs=Lophoc.joins(:hocphan,:dangkilophocs)
							.select("lophocs.*","mahocphan","tenhocphan","tinchi","tinchihocphi","hesohocphi","tinchihocphi*hesohocphi as tongphi")
							.where("hocki_id=? and sinhvien_id=?",@hocki.id,@sinhvien.id)
				else
					flash[:info]="見付からない"
				end			
			else
				flash[:info]="見付からない"					
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
			flash[:info]="見付からない"	
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
	          flash[:danger]="あなたは本人じゃない"
	          redirect_to(root_url) 
	        end
        end
    end
end
