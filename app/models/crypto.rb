class Crypto
  def initialize(date)
    @seed = date.to_date.ld
  end

  def ramrod
    @ramrod ||= Settings.ramrods.sample(random: Random.new(@seed)).upcase
  end

  def dryad
    random = Random.new(@seed)
    OpenStruct.new headers: %w[ABC DEF GHJ KL MN PQR ST UV WX YZ],
                   rows: ('A'..'Y').map { |h| OpenStruct.new(header: h, columns: dryad_row(random)) }
  end

  private

  COL_WIDTHS = [4, 3, 3, 2, 2, 3, 2, 2, 2, 2].freeze
  POS_TO_COL = [0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 4, 4, 5, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9].freeze

  def dryad_row(random)
    data = ('A'..'Y').to_a.shuffle(random: random)
    data.each_with_object([]).with_index do |(c, a), i|
      col = POS_TO_COL[i]
      a[col] = '' if a[col].nil?
      a[col] += c
    end
  end
end