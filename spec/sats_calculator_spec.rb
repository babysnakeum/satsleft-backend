require_relative '../sats_calculator'

RSpec.describe SatsCalculator do
  describe '#calculate_subsidy' do
    it 'calculates subsidy for a particular halving' do
      expect(described_class.new.calculate_subsidy(0)).to eq 5_000_000_000
      expect(described_class.new.calculate_subsidy(1)).to eq 2_500_000_000
      expect(described_class.new.calculate_subsidy(2)).to eq 1_250_000_000
      expect(described_class.new.calculate_subsidy(3)).to eq 625_000_000
    end
  end

  describe '#sats_mined_up_to_block' do
    it 'calculates amount of sats mined up to a certain block' do
      expect(described_class.new.sats_mined_up_to_block(3)).to eq (3 * 5_000_000_000)
      expect(described_class.new.sats_mined_up_to_block(205_000)).to eq (205_000 * 5_000_000_000)
      expect(described_class.new.sats_mined_up_to_block(210_000)).to eq ((209_999 * 5_000_000_000) + 2_500_000_000)
      expect(described_class.new.sats_mined_up_to_block(700_929)).to eq (1881823750000000)
      expect(described_class.new.sats_mined_up_to_block(366_000)).to eq (1439997500000000)
    end
  end

  describe '#sats_left' do
    it 'calculates amount of sats left to mine ever' do
      expect(described_class.new.sats_left(700930)).to eq 218165622690011
      expect(described_class.new.sats_left(920_000)).to eq 106248122690011
      expect(described_class.new.sats_left(6_929_999)).to eq 209967
      expect(described_class.new.sats_left(6_930_000)).to eq 0
      expect(described_class.new.sats_left(6_930_001)).to eq 0
    end
  end
end
