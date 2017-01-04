class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception 
  include SessionsHelper
  helper :all
  private

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Hãy đăng nhập trước đã."
        redirect_to login_url
      end
    end
    # Confirms an admin user.
  def is_admin
    unless admin?
      flash[:danger]="Chỉ admin mới có quyền đó !"
      redirect_to(root_url)
    end
  end
  def is_sinhvien
    unless sinhvien?
      flash[:danger]="Bạn không phải là sinh viên !"
      redirect_to(root_url) 
    end
  end
  
  # Confirms the correct user.
  def its_me
      sinhvien = Sinhvien.find_by_id(params[:id])
      unless current_sinhvien.sinhvien==sinhvien
        flash[:danger]="Bạn không phải chính chủ !"
        redirect_to(root_url) 
      end
  end
end
