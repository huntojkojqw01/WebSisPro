module LophocsHelper
	def toStrTime(intTime)
		strTime=''
		bitCheck=1
		thu=7		
		ketthuc=0
		60.downto(1) do |i|			
			if intTime&(1<<(60-i)) >0
				ketthuc=i if ketthuc==0				
			else
				if ketthuc>0																	
					strTime="Thu #{thu}:#{i+1-(thu-2)*12}-#{ketthuc-(thu-2)*12} "+strTime
					ketthuc=0					
				end
			end
			if i%12==0
				if ketthuc>i
					strTime="Thu #{thu}:1-#{ketthuc-(thu-2)*12} "+strTime
					ketthuc=i
				end
				thu-=1
			end	
		end
		strTime="Thu 2:1-#{ketthuc} "+strTime if ketthuc>0
		return strTime
	end	
end
