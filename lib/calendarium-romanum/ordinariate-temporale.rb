require 'calendarium-romanum'

module OrdinariateCalendar
   
class Temporale < ::CalendariumRomanum::Temporale

	  
      # implementation detail, not to be touched by client code
      def celebrations
        @celebrations ||=
          begin
            %i(
              nativity
              holy_family
              mother_of_god
              epiphany
              baptism_of_lord
              septuagesima
              sexagesima
              quinquagesima
              ash_wednesday
              good_friday
              holy_saturday
              palm_sunday
              easter_sunday
              ascension
              pentecost
              holy_trinity
              corpus_christi
              mother_of_church
              sacred_heart
              christ_king
              immaculate_heart
            ).collect do |symbol|
              date_method = symbol
              C.new(
                date_method,
                CelebrationFactory.public_send(symbol)
              )
            end
            # Immaculate Heart of Mary and Mary, Mother of the Church
            # are actually movable *sanctorale* feasts,
            # but as it would make little sense
            # to add support for movable sanctorale feasts because of
            # two, we cheat a bit and handle them in temporale.
          end
      end

	  
	  def by_name(name)
		 CelebrationFactory.public_send(name) 
	  end
    
    def season(date)
      if (first_advent_sunday <= date) &&
         (nativity > date)
        CalendariumRomanum::Seasons::ADVENT

      elsif (nativity <= date) &&
            (epiphany   >= date)
#               (mother_of_god   >= date)
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
#This is a hack the causes 																																																																																																																																																								 Pentecostal octave to be eigth week of easter. 
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
          #week -= 1 if date.sunday? 
          #week += 1
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
      seas = season date
      week = season_week(seas, date)
      rank = CalendariumRomanum::Ranks::FERIAL
      title = nil
      case seas
      when CalendariumRomanum::Seasons::ADVENT
		d = Date.new(@year, 12, 1)
		if date >= d && date <= d + 14
			if d.wday == 0 
				offset = 0
			else
				offset = 7 - d.wday
			end
			dec_ember = [d + offset + 3, d + offset + 5, d + offset + 6]
			if dec_ember.include? date
				rank = CalendariumRomanum::Ranks::FERIAL_PRIVILEGED
			title = I18n.t 'temporale.ember_days', weekday: I18n.t("weekday.#{date.wday}")
			end
		end

        if date >= Date.new(@year, 12, 17)
          rank = CalendariumRomanum::Ranks::FERIAL_PRIVILEGED
          nth = CalendariumRomanum::Ordinalizer.ordinal(date.day)
          title = I18n.t 'temporale.advent.before_christmas', day: nth
        end
      when CalendariumRomanum::Seasons::CHRISTMAS
        if date < mother_of_god
          rank = CalendariumRomanum::Ranks::FERIAL_PRIVILEGED

          nth = CalendariumRomanum::Ordinalizer.ordinal(date.day - nativity.day + 1) # 1-based counting
          title = I18n.t 'temporale.christmas.nativity_octave.ferial', day: nth
        elsif date > epiphany
          title = I18n.t 'temporale.christmas.after_epiphany.ferial', weekday: I18n.t("weekday.#{date.wday}")
        end
      when CalendariumRomanum::Seasons::TIME_AFTER_EPIPHANY
      when CalendariumRomanum::Seasons::LENT
        if week == 0
          title = I18n.t 'temporale.lent.after_ashes.ferial', weekday: I18n.t("weekday.#{date.wday}")
		elsif week == 1
# 			Ember days after first sunday of lent
			if [3,5,6].include? date.wday
				rank = CalendariumRomanum::Ranks::FERIAL_PRIVILEGED
				title = I18n.t 'temporale.ember_days', weekday: I18n.t("weekday.#{date.wday}")
			end
		elsif date > palm_sunday
          rank = CalendariumRomanum::Ranks::PRIMARY
          title = I18n.t 'temporale.lent.holy_week.ferial', weekday: I18n.t("weekday.#{date.wday}")
        end
        rank = CalendariumRomanum::Ranks::FERIAL_PRIVILEGED unless rank > CalendariumRomanum::Ranks::FERIAL_PRIVILEGED
      when CalendariumRomanum::Seasons::EASTER
        if week == 1
          rank = CalendariumRomanum::Ranks::PRIMARY
          title = I18n.t 'temporale.easter.octave.ferial', weekday: I18n.t("weekday.#{date.wday}")		
        end
		if week == 6
			if date.wday >= 1 && date.wday <4
				title = I18n.t 'temporale.easter.rogation', weekday: I18n.t("weekday.#{date.wday}")		
			end
		end
# 		Pentecost Ember Days
		if [pentecost + 3, pentecost + 5, pentecost + 6].include? date		
			rank = CalendariumRomanum::Ranks::FERIAL_PRIVILEGED
			title = I18n.t 'temporale.ember_days', weekday: I18n.t("weekday.#{date.wday}")

		end
		when CalendariumRomanum::Seasons::TIME_AFTER_TRINITY
		   
			d = Date.new(date.year, 9, 14)
			if date >= d && (date <= d + 14)
				if d.wday == 0
					offset = 0
				else
					offset = 7 - d.wday
				end
				sept_ember = [d + offset + 3, d + offset + 5, d + offset + 6]
				if sept_ember.include? date
					rank = CalendariumRomanum::Ranks::FERIAL_PRIVILEGED
					title = I18n.t 'temporale.ember_days', weekday: I18n.t("weekday.#{date.wday}")
			end
		   end
      end

      week_ord = CalendariumRomanum::Ordinalizer.ordinal week
      title ||= I18n.t "temporale.#{seas.to_sym}.ferial", week: week_ord, weekday: I18n.t("weekday.#{date.wday}")

      self.class.create_celebration title, rank, seas.colour
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
