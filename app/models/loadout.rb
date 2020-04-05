class Loadout < OpenStruct
  extend ActiveModel::Naming

  def initialize(hash = {})
    super hash.to_h.reject { |_, v| v.blank? }
  end

  def self.parse(loadout)
    data = loadout&.split&.map do |e|
      k, v = e.split /:/
      [k.to_sym, v]
    end
    new(data.to_h)
  end

  def to_s
    to_h.map { |k, v| "#{k}:#{v}" }.join ' '
  end

  def a2a
    select_payload %w[a2a]
  end

  def a2g
    select_payload %w[a2g agm rockets]
  end

  def tanks
    select_payload %w[tank]
  end

  def pods
    select_payload %w[pod]
  end

  private

  def select_payload(types)
    payload_amounts.select { |key| types.include? Settings.payload[key].type }
                   .map { |key, amount| "#{amount}x #{Settings.payload[key].name}" }.join(', ')
  end

  def payload_amounts
    @table.values.each_with_object({}) do |v, h|
      amount, payload = v.split /x/, 2
      amount = amount.to_i
      payload = v if amount.zero?
      payload = payload.split(/,/).first
      h[payload] = amount + (h[payload] || 0)
    end
  end
end
