require 'net/http'
require 'twitter'
require 'json'

module Satsleft
  class TwitterBot
    def initialize(block_height:, sats_left:)
      @block_height = block_height
      @sats_left = sats_left
      @current_price = current_price
    end

    def tweet
      client.update(status)
    end

    def status
      "\u{1F44B} A new block was found on the #Bitcoin network. We're at block height #{@block_height}, current #bitcoin price is $#{@current_price} and there are #{@sats_left} #sats left to mine."
    end

    def current_price
      url = URI("https://api.coinbase.com/v2/prices/BTC-USD/spot")
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true
      request = Net::HTTP::Get.new(url)
      response = JSON.parse(https.request(request).body)
      response["data"]["amount"]
    end

    def client
      @client ||= Twitter::REST::Client.new do |config|
        config.consumer_key         = ENV["TWITTER_CONSUMER_KEY"]
        config.consumer_secret      = ENV["TWITTER_CONSUMER_SECRET"]
        config.access_token         = ENV["TWITTER_ACCESS_TOKEN"]
        config.access_token_secret  = ENV["TWITTER_TOKEN_SECRET"]
      end
    end
  end
end
