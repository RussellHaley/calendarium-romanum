module CalendariumRomanum
  class Temporale
    # builds temporale Celebrations
    class CelebrationFactory
      class << self
        def each
          return to_enum(__method__) unless block_given?

          celebrations.each do |symbol|
            yield public_send(symbol)
          end
        end

        def first_advent_sunday
          Temporale.create_celebration(
            I18n.t('temporale.advent.sunday', week: Ordinalizer.ordinal(1)),
            Ranks::PRIMARY,
            Colours::VIOLET
          )
        end

        private

        def celebrations
          @celebrations ||= [:first_advent_sunday]
        end

        def celebration(symbol, rank, colour = Colours::WHITE, fixed_date: false)
          define_singleton_method(symbol) do
            Temporale.create_celebration(
              proc { I18n.t("temporale.solemnity.#{symbol}") },
              rank,
              colour,
              symbol: symbol,
              date: fixed_date
            )
          end

          celebrations << symbol
        end
      end

      # define factory methods
      celebration(:nativity, Ranks::PRIMARY, fixed_date: AbstractDate.new(12, 25))
      celebration(:holy_family, Ranks::FEAST_LORD_GENERAL)
      celebration(:mother_of_god, Ranks::SOLEMNITY_GENERAL, fixed_date: AbstractDate.new(1, 1))
      celebration(:epiphany, Ranks::PRIMARY)
      celebration(:baptism_of_lord, Ranks::FEAST_LORD_GENERAL)
#       Second Sunday After Epiphany
#       Third Sunday After Epiphany
#       Fourth Sunday After Epiphany
#       Fith Sunday After Epiphany
#       Sixth Synday After Epiphany
#       Feast of the Lord ?
#       The Presentation of the Lord (Candlemas) 
#       Third Sunday before Lent(Septuagesima)
      celebration(:septuagesima, Ranks::SOLEMNITY_GENERAL)
      celebration(:sexagesima, Ranks::SOLEMNITY_GENERAL)
      celebration(:quinquagesima, Ranks::SOLEMNITY_GENERAL)
#       Second Sunday before Lent(Sexagesima)
#       Sunday next before Lent(Quinquagesima)
      celebration(:ash_wednesday, Ranks::PRIMARY, Colours::VIOLET)
#       First Sundayin Lent
#       Second Sunday in Lent
#       Third Sunday in Lent
#       Fourth Sunday in Lent (Mothering Sunday)
#       Fifth Sunday in Lent (Passion Sunday)
#       Palm Sunday
#       Mondayof Holy Week
#       Tuesdayof Holy week
#       Wednesday of Holy Week
#       Maundy Thursday
      celebration(:good_friday, Ranks::TRIDUUM, Colours::RED)
      celebration(:holy_saturday, Ranks::TRIDUUM, Colours::VIOLET)
      celebration(:passion_sunday, Ranks::PRIMARY, Colours::RED)
      celebration(:palm_sunday, Ranks::PRIMARY, Colours::RED)
      celebration(:easter_sunday, Ranks::TRIDUUM)
#     Monday of Easter Week
#     Tuesday of Easter Week
#     Wednesday of Easter Week
#     Thursday of Easter Week
#     Friday of Easter Week
#     Saturday of Easter Week
#     Second Sunday of Easter (Divine Mercy Sunday)
#     Third Sunday of Easter
#     Fourth Sunday of Easter
#     Fifth Sunday of Easter
#     Sixth Sunday of Easter
      celebration(:ascension, Ranks::PRIMARY)
#       Seventh Sunday of Easter (Sunday after Ascension)
      celebration(:pentecost, Ranks::PRIMARY, Colours::RED)
# Pentecost Octave
      celebration(:holy_trinity, Ranks::SOLEMNITY_GENERAL)
      
      celebration(:corpus_christi, Ranks::SOLEMNITY_GENERAL)
      celebration(:sacred_heart, Ranks::SOLEMNITY_GENERAL)
      celebration(:christ_king, Ranks::SOLEMNITY_GENERAL)

      #2019-09-28: rhaley - these don't seem to be in the Ordinariate calendar?
      celebration(:mother_of_church, Ranks::MEMORIAL_GENERAL)
      celebration(:immaculate_heart, Ranks::MEMORIAL_GENERAL)
      celebration(:saturday_memorial_bvm, Ranks::MEMORIAL_OPTIONAL)
    end
  end
end
