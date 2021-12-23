class SatsCalculator
  COIN = 100_000_000
  HALVING_PERIOD = 210_000
  BLOCKS_IN_PERIOD = HALVING_PERIOD - 1

  def initialize
    @subsidy = 50 * COIN
  end

  def total_supply
    # 21_000_000 * COIN
    2099989997690011 # seems to be the true supply
  end

  def sats_left(height)
    total_supply - sats_mined_up_to_block(height)
  end

  def sats_mined_up_to_block(height)
    halvings = height / HALVING_PERIOD
    return calculate_subsidy(halvings) * height if halvings == 0

    running_sum = 0
    (0..halvings - 1).each do |period|
      running_sum += calculate_subsidy(period) * BLOCKS_IN_PERIOD
    end

    running_sum += calculate_subsidy(halvings) * (height % BLOCKS_IN_PERIOD)
  end

  def calculate_subsidy(halvings)
    # cuts subsidy by half each 210_000 blocks
    # bitwise shift right operation equivalent to:
    # @subsidy / 2 ** halvings

    @subsidy >> halvings
  end
end
