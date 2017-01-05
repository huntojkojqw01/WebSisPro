module SessionsHelper
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
  def current_sinhvien
    if sinhvien?
      current_user.sinhvien
    else
      return nil
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
    hockis=Hocki.where("bd<=? and kt>=?",date,date)
    if hockis.count>0
      @hocki=hockis.first
    else
      @hocki=nil
    end
  end
  def current_hocki_modklophoc
    @hocki=Hocki.find_by(modangkilophoc: true)
  end
  def current_hocki_modkhocphan
    @hocki=Hocki.find_by(modangkihocphan: true)
  end
  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end
  def admin?
    !current_user.nil? && current_user.loai=="ad"
  end
  def sinhvien?
    !current_user.nil? && current_user.loai=="sv"
  end
  def giaovien?
    !current_user.nil? && current_user.loai=="gv"
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
end
