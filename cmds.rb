require 'calendarium-romanum'

year = 2019
#sanctorale = CalendariumRomanum::SanctoraleLoader.new.load_from_file 'data/ordinariate-en.txt'
sanctorale = CalendariumRomanum::SanctoraleLoader.new.load_from_file 'data/universal-en.txt'
temporale = OrdinariateCalendar::Temporale.new(year)
calendar = CalendariumRomanum::Calendar.new(year, sanctorale, temporale)

