class Position
  attr_reader :latitude, :longitude, :dme

  def initialize(latitude: nil, longitude: nil, pos: nil, dme: nil)
    if latitude.present? && longitude.present?
      @latitude = latitude.to_d
      @longitude = longitude.to_d
    else
      parse(pos) if pos.present?
    end

    @dme ||= dme

    @dme = pos if @latitude.nil? && @longitude.nil? && @dme.nil?
  end

  def coords(type = :dm)
    return '' if @longitude.nil? || @latitude.nil?

    case type
    when :dms
      "#{lat_to_dms} #{lon_to_dms}"
    when :dmsp
      "#{lat_to_dms(2)} #{lon_to_dms(2)}"
    when :dmp
      "#{lat_to_dm(4)} #{lon_to_dm(4)}"
    else
      "#{lat_to_dm} #{lon_to_dm}"
    end
  end

  def to_s(type = :dm)
    return @dme if @latitude.nil? && @longitude.nil?

    @dme.nil? ? coords(type) : "#{@dme} (#{coords(type)})"
  end

  private

  MAPPINGS = { n: 1, s: -1, w: -1, e: 1 }.freeze

  def parse(pos)
    @latitude = extract_part(pos, 'N|S', 2)
    @longitude = extract_part(pos, 'W|E', 3)
    @dme = extract_dmes(pos)
  end

  def extract_part(pos, letters, deg_len)
    regex = "(?<let>#{letters})(?<deg>\\d{#{deg_len}}(?:\\.\\d+)?)°?\\s*(?<min>\\d\\d(?:\\.\\d+)?)?'?\\s*(?<sec>\\d\\d(?:\\.\\d+)?)?"
    match = pos.match regex
    return nil unless match

    let = match[:let]
    deg = match[:deg].to_d
    min = match[:min].to_d
    sec = match[:sec].to_d

    letter_to_sign(let) * (deg + min / 60 + sec / 3600)
  end

  def extract_dmes(pos)
    dmes = pos.scan(%r{[A-Z]{3} \d{3}/\d+(?:\.\d+)?}).join(' ')
    dmes.present? ? dmes : nil
  end

  def from_dm(letter, deg, min)
    letter_to_sign(letter) * (deg + min / 60.0)
  end

  def letter_to_sign(letter)
    MAPPINGS[letter.downcase.to_sym]
  end

  def lat_to_dm(precision = 3)
    value = @latitude.abs
    "#{lat_letter}#{to_dm(value, 2, precision)}"
  end

  def lon_to_dm(precision = 3)
    value = @longitude.abs
    "#{lon_letter}#{to_dm(value, 3, precision)}"
  end

  def lat_to_dms(precision = 0)
    value = @latitude.abs
    "#{lat_letter}#{to_dms(value, 2, precision)}"
  end

  def lon_to_dms(precision = 0)
    value = @longitude.abs
    "#{lon_letter}#{to_dms(value, 3, precision)}"
  end

  def lat_letter
    @latitude.negative? ? 'S' : 'N'
  end

  def lon_letter
    @longitude.negative? ? 'W' : 'E'
  end

  def to_dm(value, digits, precision)
    d = value.to_i
    m = (value.frac * 60).round(precision)

    if m.zero?
      format "%0#{digits}d", d
    else
      m_format = m.frac.zero? ? '%02d' : "%0#{precision + 3}.#{precision}f"

      format "%0#{digits}d #{m_format}", d, m
    end
  end

  def to_dms(value, digits, precision)
    d = value.to_i
    m = value.frac * 60
    s = (m.frac * 60).round(precision)
    m = m.to_i

    if s.zero?
      if m.zero?
        format "%0#{digits}d", d
      else
        format "%0#{digits}d %02d", d, m
      end
    else
      s_format = s.frac.zero? ? '%02d' : "%0#{precision + 3}.#{precision}f"
      format "%0#{digits}d %02d #{s_format}", d, m, s
    end
  end
end
