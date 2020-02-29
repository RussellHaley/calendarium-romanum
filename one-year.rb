require 'calendarium-romanum'
require 'parse_psalms'


year = 2019

holy_days_file='data/psalms/Psalms-for-sundays-and-holy-days.txt'
ordinary_days_file='data/psalms/Psalms-ordinary-weekdays.txt'
psalms_saints_file = 'data/psalms/Psalms-for-saints.txt' 
pfd = PsalmsForDays.new

sanctorale = CalendariumRomanum::SanctoraleLoader.new.load_from_file 'data/ordinariate-en.txt'
temporale = OrdinariateCalendar::Temporale.new(year)


calendar = CalendariumRomanum::Calendar.new(year, sanctorale, temporale)
psalms_ordinary = 	pfd.read_file(ordinary_days_file)
psalms_holy_days = pfd.read_file(holy_days_file)
psalms_saints = pfd.read_file(psalms_saints_file)

start_date = Date.new(year,1,1)

end_date = Date.new(year,12,31)

days = Array.new(365)
 
for i in 0..364
	days[i] = calendar.day(start_date.month,start_date.day)
# 	puts(start_date)
	start_date += 1	
end

def generate_data(days, pfd, psalms_ordinary)
	
	days.each do |day|
		puts "Calendar Date: #{day.date.to_s} #{day.date.strftime('%A')}"
		celebration = day.celebrations[0]
		day.celebrations.each do | c |
			puts "\t" + c.title
		end		
		psalms = pfd.get_ordinary_psalm(day.date, psalms_ordinary)
	# 	puts celebration.symbol
	# 	   psalms = pfd.get_saint_psalm(celebration.symbol.to_s, psalms_saints)
	# 	   psalms = pfd.get_holy_day_psalm(celebration.symbol.to_s, psalms_holy_days)
		puts "psalms: #{psalms.join(' : ')}"
		puts "---------------------"
	end
end

generate_data(days, pfd, psalms_ordinary)
