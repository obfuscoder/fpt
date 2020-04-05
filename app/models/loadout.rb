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
end
