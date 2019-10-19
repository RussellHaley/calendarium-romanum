require 'date'

class PsalmsForDays
	def read_file(file)
		psalms = []
		File.readlines(file).each do |line|
			if line[0,1] != "#" 
				if line.strip == ""
					next
				end
	#             puts line
				psalms << line.split("\t")
			else
				#A comment line
			end
		end
		return psalms
	end


	def get_ordinary_psalm(date, list)
	# 	calendar index. Odd Months = 1 Even Months = 2. 
		ci = 1
		if date.month % 2 == 0
			ci = 2
		end
		
	# 	now look up the psalms by the calendar index and the day
		list.each do |item|	
			if item[0].to_i == ci and item[1].to_i == date.day
				return item
			end
		end
	end

	def get_holy_day_psalm(celebration, list)
	# 	now look up the psalms by the calendar index and the day
		list.each do |item|	
			if item[0] == celebration
				return item[2..item.length]
			end
		end
		return nil
	end

	def get_saint_psalm(symbol, list)
		# 	now look up the psalms by the calendar index and the day
		list.each do |item|	
			if item[0] == symbol
				return item[2..item.length]
			end
		end
		return nil
	end

	# puts get_ordinary_psalm(DateTime.now, read_file(ordinary_days_file)).join(' : ')
	# 
	# puts get_holy_day_psalm("Trinity 1", read_file(holy_days_file)).join(' : ')
end
