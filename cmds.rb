require 'calendarium-romanum'
# require 'ordinariate-temporale'

first, second, third = ARGV

year = first.to_i
month = second.to_i
day = third.to_i
#sanctorale = CalendariumRomanum::SanctoraleLoader.new.load_from_file 'data/ordinariate-en.txt'
sanctorale = CalendariumRomanum::SanctoraleLoader.new.load_from_file 'data/ordinariate-en.txt'

temporale = OrdinariateCalendar::Temporale.new(year)
calendar = CalendariumRomanum::Calendar.new(year, sanctorale, temporale)

day = calendar.day(month,day)

puts day.date.to_s, day.celebrations[0].title, day.celebrations[1].title
