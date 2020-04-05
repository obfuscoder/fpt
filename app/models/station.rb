class Station
  def initialize(config, payload)
    @config = config
    @payload = payload
  end

  def number
    @config.first
  end

  def options
    @options ||= @config.second.map { |option| Option.new(option, @payload) }
    @options.map(&:to_a)
  end

  class Option
    def initialize(config, payload)
      @config = config
      @payload = payload
    end

    def to_a
      weapon = Settings.payload[@config.weapon]
      pylon = Settings.payload[@config.pylon]
      amount = weapon ? @config.amount || 1 : 0
      text = [weapon&.name, pylon&.name].compact.join ' - '
      value = [@config.weapon, @config.pylon].compact.join ','
      if amount > 0
        text = "#{amount}x #{text}"
        value = "#{amount}x#{value}"
      end
      [text, value]
    end
  end
end
