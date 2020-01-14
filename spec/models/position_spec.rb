require 'rails_helper'

RSpec.describe Position do

  describe '#new(pos:)' do
    subject(:instance) { described_class.new pos: pos }

    {
      'N12 34.5678 W123 56.321' => 'N12 34.568 W123 56.321',
      'N12° 34.5678\' W123°56.321' => 'N12 34.568 W123 56.321',
      'N12°34\'45" W123 56 30' => 'N12 34.750 W123 56.500',
      'LSV 269/33 (N36 21 26.400 W115 41 28.200)' => 'LSV 269/33 (N36 21.440 W115 41.470)',
      'N36 34.425 W116 02.444' => 'N36 34.425 W116 02.444',
      'LAS 354/66 BLD 342/71 (N37 10.340 W114 59.530)' => 'LAS 354/66 BLD 342/71 (N37 10.340 W114 59.530)',
      'S36 14 40.800 E115 01 30' => 'S36 14.680 E115 01.500',
      'N5952 W11534' => 'N59 52 W115 34',
      'N5952.000 W11534.000' => 'N59 52 W115 34',
      'N595230 W1153415' => 'N59 52.500 W115 34.250',
      'N595230.250 W1153415.134' => 'N59 52.504 W115 34.252',
      'ABC 123/5.2 (N59 W115)' => 'ABC 123/5.2 (N59 W115)',
      'XYZ 001/2.4 - N12.3456789012345 W123.456789012345678' => 'XYZ 001/2.4 (N12 20.741 W123 27.407)'
    }.each do |input, output|
      context "with #{input}" do
        let(:pos) { input }
        let(:expected_result) { output }

        its(:to_s) { is_expected.to eq expected_result }
      end
    end
  end
end
