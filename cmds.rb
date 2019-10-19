require 'calendarium-romanum'
require 'parse_psalms'
# require 'ordinariate-temporale'

first, second, third, fourth, fifth = ARGV

year = first.to_i
start_month = second.to_i
start_day = third.to_i
end_month = fourth.to_i
end_day = fifth.to_i

holy_days_file='data/psalms/Psalms-for-sundays-and-holy-days.txt'
ordinary_days_file='data/psalms/Psalms-ordinary-weekdays.txt'
psalms_saints_file = 'data/psalms/Psalms-for-saints.txt' 
pfd = PsalmsForDays.new

sanctorale = CalendariumRomanum::SanctoraleLoader.new.load_from_file 'data/ordinariate-en.txt'
temporale = OrdinariateCalendar::Temporale.new(year)

#  puts temporale.celebrations
 
i = temporale[Date.new(2018,12,25)]

puts i
#  puts "#{temporale.by_name(:nativity).date.month} #{temporale.by_name(:nativity).date.day}"
# temporale.celebrations.each do | c|
# 	puts c
# end
calendar = CalendariumRomanum::Calendar.new(year, sanctorale, temporale)
psalms_ordinary = 	pfd.read_file(ordinary_days_file)
psalms_holy_days = pfd.read_file(holy_days_file)
psalms_saints = pfd.read_file(psalms_saints_file)
start_date = Date.new(year,start_month, start_day)

# puts sanctorale
if fourth == nil then
    end_month = start_month
    end_day = start_day
end
end_date = Date.new(year,end_month, end_day)


while start_date <= end_date do
    day = calendar.day(start_date.month,start_date.day)

    puts "Calendar Date: #{day.date.to_s} #{day.date.strftime('%A')}"
    celebration = day.celebrations[0]
    day.celebrations.each do | c |
       puts "\t" + c.title
# 	   puts c	   
	end
	
	psalms = pfd.get_ordinary_psalm(start_date, psalms_ordinary)
# 	puts celebration.symbol
# 	   psalms = pfd.get_saint_psalm(celebration.symbol.to_s, psalms_saints)
# 	   psalms = pfd.get_holy_day_psalm(celebration.symbol.to_s, psalms_holy_days)
	puts "psalms: #{psalms.join(' : ')}"	
    start_date = start_date + 1
end
   
# puts "Date #{start_date} name #{start_date.strftime('%A')}"


# puts day

def octave (year, day, month)
#    //find the previous sunday and create a sunday to sunday calendar 
end
