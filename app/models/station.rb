class Station
  def initialize(config)
    @config = config
  end

  def number
    @config.first
  end

  def grouped_options
    options.group_by(&:type)
  end

  def options
    @options ||= @config.second.map { |option| LoadoutOption.new(option) }
  end
end
