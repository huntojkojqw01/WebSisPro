module ApplicationHelper
	def full_title title=""
		return title=="" ? "Rails by ProTeam" : title+" | WebSisPro"
	end
	def hello
		case current_user.loai
		when "ad"
			return "Xin chao admin"
		when "sv"
			return "Xin chao sinh vien"
		when "gv"
			return "Xin chao giao vien"
		else
		end
	end
end
