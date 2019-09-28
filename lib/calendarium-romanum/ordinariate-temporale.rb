require 'calendarium-romanum'

module OrdinariateCalendar
  class Temporale < ::CalendariumRomanum::Temporale
    # most of the hard work comes here
      
    def season(date)
      range_check date

      if (first_advent_sunday <= date) &&
         (nativity > date)
        Seasons::ADVENT

      elsif (nativity <= date) &&
            (mother_of_god   >= date)
        Seasons::CHRISTMAS

      elsif (epiphany <= date) &&
              (baptism_of_lord >= date)
          Seasons::EPIPHANY
      elsif(baptism_of_lord <=date) &&
              (ash_wednesday <= date)
        Seasons::TIME_AFTER_EPIPHANY
      elsif (ash_wednesday <= date) &&
            easter_sunday > date
        Seasons::LENT

      elsif (easter_sunday <= date) &&
            (pentecost >= date)
        Seasons::EASTER        
      else
#         Seasons::ORDINARY
          Seasons::TIME_AFTER_TRINITY
      end
    end

    def season_beginning(s)
      case s
      when Seasons::ADVENT
        first_advent_sunday
      when Seasons::CHRISTMAS
        nativity
      when Seasons::EPIPHANY
        epiphany
      when Seasons::TIME_AFTER_EPIPHANY
          baptism_of_lord
      when Seasons::LENT
        ash_wednesday
      when Seasons::EASTER
        easter_sunday
#       when Seasons::ORDINARY # ordinary time
#         baptism_of_lord + 1
      when Seasons::TIME_AFTER_TRINITY
          corpus_christi
      else
        raise ArgumentError.new('unsupported season')
      end
    end

    def season_week(seasonn, date)
      week1_beginning = season_beginning = season_beginning(seasonn)
      unless season_beginning.sunday?
        week1_beginning = Dates.sunday_after(season_beginning)
      end

      week = date_difference(date, week1_beginning) / WEEK + 1
      
#       if seasonn == Seasons::ORDINARY
      if seasonn == Seasons::TIME_AFTER_TRINITY
        # ordinary time does not begin with Sunday, but the first week
        # is week 1, not 0
        week += 1

        if date > pentecost
          weeks_after_date = date_difference(Dates.first_advent_sunday(@year + 1), date) / WEEK
          week = 34 - weeks_after_date
          week += 1 if date.sunday?
        end
      end

      week
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
  
  private

    # seasons when Sundays have higher rank
#     SEASONS_SUNDAY_PRIMARY = [Seasons::ADVENT, Seasons::LENT, Seasons::EASTER].freeze
end

