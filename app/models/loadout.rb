class Loadout < OpenStruct
  extend ActiveModel::Naming

  def initialize(airframe, hash = {})
    @airframe = airframe
    super hash.to_h.reject { |_, v| v.blank? }
  end

  def self.parse(airframe, loadout)
    data = loadout&.split&.map do |e|
      k, v = e.split /:/
      [k.to_sym, v]
    end
    new(airframe, data.to_h)
  end

  def to_s
    to_h.map { |k, v| "#{k}:#{v}" }.join ' '
  end

  def a2a(text: :name)
    select_payload types: %w[a2a], text: text
  end

  def a2g(text: :name)
    select_payload types: %w[a2g agm rockets], text: text
  end

  def tanks(text: :name)
    select_payload types: %w[tank], text: text
  end

  def pods(text: :name)
    select_payload types: %w[pod], text: text
  end

  def gun_amount
    @table[:g]&.split(/,/)&.first || 100
  end

  def gun_type
    @table[:g]&.split(/,/)&.second
  end

  def gun
    return '' unless @table[:g]

    type = Settings.airframes[@airframe].gun.types[gun_type]
    "#{gun_amount}% #{type}"
  end

  def chaff

  end

  def flares

  end

  def fuel
    @table[:f]
  end

  private

  def select_payload(types:, text:)
    payload_amounts.select { |key| types.include? Settings.payload[key].type }
                   .map { |key, amount| payload_text(amount, key, text) }.join(', ')
  end

  def payload_text(amount, key, text)
    amount = amount > 1 ? "#{amount}x" : ''
    name = Settings.payload[key].send(text) || Settings.payload[key].name
    amount + name
  end

  def payload_amounts
    @table.reject { |k, _| %i[g f d].include? k }.values.each_with_object({}) do |v, h|
      amount, payload = v.split /x/, 2
      amount = amount.to_i
      payload = v if amount.zero?
      payload = payload.split(/,/).first
      h[payload] = amount + (h[payload] || 0)
    end
  end
end
