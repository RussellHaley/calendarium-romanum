require 'calendarium-romanum'

module OrdinariateCalendar
  class Temporale < ::CalendariumRomanum::Temporale
    # most of the hard work comes here
      
    def season(date)
        super
    end

    def season_week(seasonn, date)
        super
    end
      
    def season_beginning(s)
        super
    end
    
    def prepare_solemnities
       super 
    end

    def ferial(date)
        super
    end

    def sunday(date)
        super
    end
  end
end

