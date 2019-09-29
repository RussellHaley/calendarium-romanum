module CalendariumRomanum
  module ValueObjectInterface
    attr_reader :symbol
    alias to_sym symbol

    def name
      I18n.t @i18n_key
    end

    def to_s
      "#<#{self.class.name} #{symbol}>"
    end
  end

  class Colour
    include ValueObjectInterface

    def initialize(symbol)
      @symbol = symbol
      @i18n_key = "colour.#{@symbol}"
    end
  end

  class Colours < Enum
    values(index_by: :symbol) do
      [
        GREEN = Colour.new(:green),
        VIOLET = Colour.new(:violet),
        WHITE = Colour.new(:white),
        RED = Colour.new(:red),
        ROSE = Colour.new(:rose)
      ]
    end
  end

  Colors = Colours

  class Season
    include ValueObjectInterface

    def initialize(symbol, colour)
      @symbol = symbol
      @colour = colour
      @i18n_key = "temporale.season.#{@symbol}"
    end

    attr_reader :colour
  end

#   class Seasons < Enum
#     values(index_by: :symbol) do
#       [
#         ADVENT = Season.new(:advent, Colours::VIOLET),
#         CHRISTMAS = Season.new(:christmas, Colours::WHITE),
#         LENT = Season.new(:lent, Colours::VIOLET),
#         EASTER = Season.new(:easter, Colours::WHITE),
#         ORDINARY = Season.new(:ordinary, Colours::GREEN)
#       ]
#     end
#   end


  class Seasons < Enum
    values(index_by: :symbol) do
      [
        ADVENT = Season.new(:advent, Colours::VIOLET),
        CHRISTMAS = Season.new(:christmas, Colours::WHITE),
        EPIPHANY = Season.new(:epiphany, Colours::ROSE),
        TIME_AFTER_EPIPHANY = Season.new(:time_after_epiphany, Colours::ROSE),
        LENT = Season.new(:lent, Colours::VIOLET),
        EASTER = Season.new(:easter, Colours::WHITE),
        TIME_AFTER_TRINITY = Season.new(:time_after_trinity, Colours::GREEN),
        ORDINARY = Season.new(:ordinary, Colours::GREEN)
      ]
    end
  end

  
  LECTIONARY_CYCLES = [:A, :B, :C].freeze

  # ranks of celebrations
  class Ranks < Enum
    values(index_by: :priority) do
      # Values are at the same time references to sections
      # of the Table of Liturgical Days.
      # The lower value, the higher rank.
      [
        TRIDUUM           = Rank.new(1.1, 'rank.1_1'),
        PRIMARY           = Rank.new(1.2, 'rank.1_2'), # description may not be exact
        SOLEMNITY_GENERAL = Rank.new(1.3, 'rank.1_3', 'rank.short.solemnity'), # description may not be exact
        SOLEMNITY_PROPER  = Rank.new(1.4, 'rank.1_4', 'rank.short.solemnity'),

        FEAST_LORD_GENERAL  = Rank.new(2.5, 'rank.2_5', 'rank.short.feast'),
        SUNDAY_UNPRIVILEGED = Rank.new(2.6, 'rank.2_6', 'rank.short.sunday'),
        FEAST_GENERAL       = Rank.new(2.7, 'rank.2_7', 'rank.short.feast'),
        FEAST_PROPER        = Rank.new(2.8, 'rank.2_8', 'rank.short.feast'),
        FERIAL_PRIVILEGED   = Rank.new(2.9, 'rank.2_9', 'rank.short.ferial'),

        MEMORIAL_GENERAL  = Rank.new(3.10, 'rank.3_10', 'rank.short.memorial'),
        MEMORIAL_PROPER   = Rank.new(3.11, 'rank.3_11', 'rank.short.memorial'),
        MEMORIAL_OPTIONAL = Rank.new(3.12, 'rank.3_12', 'rank.short.memorial_opt'),
        FERIAL            = Rank.new(3.13, 'rank.3_13', 'rank.short.ferial'),
        # not included as a celebration rank on it's own
        # in the Table of Liturgical Days
        COMMEMORATION     = Rank.new(4.0,  'rank.4_0', 'rank.short.commemoration')
      ]
    end
  end
end
