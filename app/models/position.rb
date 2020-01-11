class Position
  def initialize(latitude: nil, longitude: nil, pos: nil)
    if latitude.present? && longitude.present?
      @latitude = latitude.to_d
      @longitude = longitude.to_d
    else
      ll(pos)
    end

    if @latitude.nil? || @longitude.nil?
      raise "Invalid! #{latitude} #{longitude} #{pos}"
    end
  end

  def to_s(type: :dm)
    case type
    when :dm
      "#{lat_to_dm} #{lon_to_dm}"
    when :dms
      "#{lat_to_dms} #{lon_to_dms}"
    end
  end

  private

  MAPPINGS = { n: 1, s: -1, w: -1, e: 1 }.freeze

  def ll(pos)
    match = pos.match /(\w)(\d\d)(\d\d\.?\d*) (\w)(\d\d\d)(\d\d\.?\d*)/
    return if match.nil?

    lat_let = match[1]
    lat_deg = match[2].to_d
    lat_min = match[3].to_d
    lon_let = match[4]
    lon_deg = match[5].to_d
    lon_min = match[6].to_d

    @latitude = from_dm(lat_let, lat_deg, lat_min)
    @longitude = from_dm(lon_let, lon_deg, lon_min)
  end

  def from_dm(letter, deg, min)
    letter_to_sign(letter) * (deg + min / 60.0)
  end

  def letter_to_sign(letter)
    MAPPINGS[letter.downcase.to_sym]
  end

  def lat_to_dm
    value = @latitude.abs
    "#{lat_letter}#{to_dm(value, 2)}"
  end

  def lon_to_dm
    value = @longitude.abs
    "#{lon_letter}#{to_dm(value, 3)}"
  end

  def lat_to_dms
    value = @latitude.abs
    "#{lat_letter}#{to_dms(value, 2)}"
  end

  def lon_to_dms
    value = @longitude.abs
    "#{lon_letter}#{to_dms(value, 3)}"
  end

  def lat_letter
    @latitude.negative? ? 'S' : 'N'
  end

  def lon_letter
    @longitude.negative? ? 'W' : 'E'
  end

  def to_dm(value, digits)
    d = value.to_i
    m = (value.frac * 60).round(3)
    m_format = m.frac.zero? ? '%02d' : '%06.3f'

    format "%0#{digits}d #{m_format}", d, m
  end

  def to_dms(value, digits)
    d = value.to_i
    m = value.frac * 60
    s = (m.frac * 60).round(3)
    m = m.to_i

    s_format = s.frac.zero? ? '%02d' : '%06.3f'
    format "%0#{digits}d %02d #{s_format}", d, m, s
  end
end
