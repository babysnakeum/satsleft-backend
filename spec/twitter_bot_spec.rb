require_relative '../twitter_bot'

RSpec.describe Satsleft::TwitterBot do
  describe '#current_price' do
    it 'fetches current price from coinbase' do
      expect(
        described_class.new(block_height: 1, sats_left: 1).current_price
      ).to match(/\d+/)
    end
  end
end
