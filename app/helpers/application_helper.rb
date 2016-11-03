module ApplicationHelper
	def full_title title=""
		return title=="" ? "Rails by ProTeam" : title+" | WebSisPro"
	end
end
