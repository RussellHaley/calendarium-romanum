require 'calendarium-romanum'

module OrdinariateCalendar
   
class Temporale < ::CalendariumRomanum::Temporale
    def season(date)
      if (first_advent_sunday <= date) &&
         (nativity > date)
        CalendariumRomanum::Seasons::ADVENT

      elsif (nativity <= date) &&
            (mother_of_god   >= date)
        CalendariumRomanum::Seasons::CHRISTMAS

      elsif (epiphany <= date) &&
              (baptism_of_lord >= date)
          CalendariumRomanum::Seasons::EPIPHANY
      elsif(baptism_of_lord <=date) &&
              (ash_wednesday > date)
        CalendariumRomanum::Seasons::TIME_AFTER_EPIPHANY
      elsif (ash_wednesday <= date) &&
            easter_sunday > date
        CalendariumRomanum::Seasons::LENT
      elsif (easter_sunday <= date) &&
            (holy_trinity >= date)
          #This is a hack the causes Pentecostal octave to be eigth week of easter. 
#             (pentecost >= date)
        CalendariumRomanum::Seasons::EASTER
      elsif (holy_trinity <= date)
          CalendariumRomanum::Seasons::TIME_AFTER_TRINITY
      end
    end

    def season_beginning(s)
      case s
      when CalendariumRomanum::Seasons::ADVENT
        first_advent_sunday
      when CalendariumRomanum::Seasons::CHRISTMAS
        nativity
      when CalendariumRomanum::Seasons::EPIPHANY
        epiphany
      when CalendariumRomanum::Seasons::TIME_AFTER_EPIPHANY
          baptism_of_lord
      when CalendariumRomanum::Seasons::LENT
        ash_wednesday
      when CalendariumRomanum::Seasons::EASTER
        easter_sunday
#       when CalendariumRomanum::Seasons::ORDINARY # ordinary time
#         baptism_of_lord + 1
      when CalendariumRomanum::Seasons::TIME_AFTER_TRINITY
          holy_trinity
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

      if seasonn == CalendariumRomanum::Seasons::TIME_AFTER_EPIPHANY
         week -= 1 if date.sunday? 
      end

      if seasonn == CalendariumRomanum::Seasons::TIME_AFTER_TRINITY
         week -= 1 if date.sunday? 
      end

      week
    end
      
    def prepare_solemnities
       super 
    end

    def ferial(date)
        super
    end

  private

    # seasons when Sundays have higher rank
    SEASONS_SUNDAY_PRIMARY = [CalendariumRomanum::Seasons::ADVENT, CalendariumRomanum::Seasons::LENT, CalendariumRomanum::Seasons::EASTER].freeze
  
      def sunday(date)
        return nil unless date.sunday?

      seas = season date
      rank = CalendariumRomanum::Ranks::SUNDAY_UNPRIVILEGED
      if SEASONS_SUNDAY_PRIMARY.include?(seas)
        rank = CalendariumRomanum::Ranks::PRIMARY
      end

      week = CalendariumRomanum::Ordinalizer.ordinal season_week(seas, date)
      title = I18n.t "temporale.#{seas.to_sym}.sunday", week: week

      self.class.create_celebration title, rank, seas.colour
    end

#class
  end
end

