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
    @options.map(&:to_a).each_with_object({}) do |e, h|
      h[e.first] = {} unless h.key? e.first
      h[e.first][e.second.first] = e.second.second
    end.each_with_object({}) do |(k, v), h|
      h[Settings.payload.types[k]] = v
    end
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
      if amount.positive?
        text = "#{amount}x #{text}"
        value = "#{amount}x#{value}"
      end
      [weapon&.type || pylon.type, [text, value]]
    end
  end
end
