module SessionsHelper
    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください"
        redirect_to login_url
      end
    end
    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless @user == current_user
    end
    # Confirms an admin user.
  def is_admin
    unless admin?
      flash[:danger]="アドミン要求"
      redirect_to(root_url)
    end
  end
  def is_sinhvien
    unless sinhvien?
      flash[:danger]="あなたは学生じゃない"
      redirect_to(root_url) 
    end
  end
  
	# Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end
  # Returns the current logged-in user (if any).
  def current_user
  	if id=session[:user_id]
    		@current_user ||= User.find_by(id: id)
    	elsif id=cookies.signed[:user_id]
    		user=User.find_by(id: id)
    		if user && user.authenticate?(cookies[:remember_token])
    			log_in user
    			@current_user=user
    		end
    end
  end
  
  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end
  
   # Remembers a user in a persistent session
  def remember(user)
  	user.remember
  	cookies.permanent.signed[:user_id]=user.id
  	cookies.permanent[:remember_token]=user.remember_token
  end
  # Returns true if the given user is the current user.
  def current_user?(user)
    user == current_user
  end
  # Forgets a persistent session.
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Logs out the current user.
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
  # Redirects to stored location (or to the default).
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
  def admin?    
    !current_user.nil? && current_user.loai=="ad"
  end
  def sinhvien?    
    if current_user && current_user.loai=="sv"       
      @current_sinhvien=Sinhvien.find_by_user_id(@current_user.id)        
    end    
  end  
  
  def last_hocki
    date=DateTime.now.to_date
    hockis=Hocki.where("bd<=? and kt>=?",date,date)
    if hockis.count>0
      @hocki=hockis.first
    else
      hockis=Hocki.where("kt<=?",date).order(:kt)
      if hockis.count>0
        @hocki=hockis.last
      else
        @hocki=Hocki.order(:kt).last
      end
    end    
  end
  def current_hocki
    date=DateTime.now.to_date
    @current_hocki=Hocki.where("bd<=? and kt>=?",date,date).first    
  end
  def mo_dangki_lophoc?
    @hocki_modangkilophoc=Hocki.find_by_modangkilophoc(true)
  end
  def mo_dangki_hocphan?
    @hocki_modangkihocphan=Hocki.find_by_modangkihocphan(true)
  end
end
