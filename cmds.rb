require 'calendarium-romanum'
# require 'ordinariate-temporale'

first, second, third, fourth, fifth = ARGV

year = first.to_i
start_month = second.to_i
start_day = third.to_i
end_month = fourth.to_i
end_day = fifth.to_i
sanctorale = CalendariumRomanum::SanctoraleLoader.new.load_from_file 'data/ordinariate-en.txt'

temporale = OrdinariateCalendar::Temporale.new(year)
calendar = CalendariumRomanum::Calendar.new(year, sanctorale, temporale)

start_date = Date.new(year,start_month, start_day)

end_date = Date.new(year,end_month, end_day)

while start_date <= end_date do
    day = calendar.day(start_date.month,start_date.day)

    puts "Calendar Date: " + day.date.to_s
    
    day.celebrations.each do | c |
       puts "\t" + c.title
    end
    start_date = start_date + 1
end

def octave (year, day, month)
#    //find the previous sunday and create a sunday to sunday calendar 
end
