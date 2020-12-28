require 'calendarium-romanum'
require 'parse_psalms'

year = Time.now.year
if ARGV.length == 1 then
	#TODO: check if it's a real year
	year = ARGV[0].to_i
end

puts "*********************************************************"
puts "*	St. John Henry Newman Catholic Church		*"
puts "*	Calendar For Litergical year: #{year} to #{year+1}	*"
puts "*	Generated on #{Time.now}		*"
puts "*********************************************************"
puts""


holy_days_file='data/psalms/Psalms-for-sundays-and-holy-days.txt'
ordinary_days_file='data/psalms/Psalms-ordinary-weekdays.txt'
psalms_saints_file = 'data/psalms/Psalms-for-saints.txt' 
pfd = PsalmsForDays.new

sanctorale = CalendariumRomanum::SanctoraleLoader.new.load_from_file 'data/ordinariate-en.txt'
temporale = OrdinariateCalendar::Temporale.new(year)

psalms_ordinary = 	pfd.read_file(ordinary_days_file)
psalms_holy_days = pfd.read_file(holy_days_file)
psalms_saints = pfd.read_file(psalms_saints_file)

#~ calendar = CalendariumRomanum::Calendar.new(year, sanctorale, temporale)
#~ calendar.each do |day|
CalendariumRomanum::Calendar.new(year, sanctorale, temporale).each do |day|
	puts "Calendar Date: #{day.date} #{day.date.strftime('%A')}"
		celebration = day.celebrations[0]
		day.celebrations.each do | c |
			puts "\t" + c.title
		end		
		psalms = pfd.get_ordinary_psalm(day.date, psalms_ordinary)
		puts "psalms: #{psalms.join(' : ')}"
		puts "---------------------"
end
