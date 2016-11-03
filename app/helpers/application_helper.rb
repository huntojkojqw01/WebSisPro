module ApplicationHelper
	def full_title title=""
		return title=="" ? "Rails by ProTeam" : title+" | WebSisPro"
	end
	def hello
		case current_user.loai
		when "ad"
			return "Xin chao Admin"
		when "sv"
			return "Xin chao Sinh vien"
		when "gv"
			return "Xin chao Giao vien"
		else
		end
	end
end
