require 'zmq'
require 'socket'
require 'bitcoin'
require 'net/http'
require_relative './sats_calculator'
require_relative './twitter_bot'

ctx = ZMQ::Context.new
socket = ctx.socket(:SUB)
socket.subscribe("rawblock")
socket.verbose = true
socket.connect("tcp://bitcoin_node:28332")
socket.linger = 1

loop do
  data = socket.recv
  puts "------"
  puts
  next if data == "rawblock"
  hash = data.chars.map { |c| c.unpack("H*") }.join
  block = Bitcoin::Block.parse_from_payload(hash.htb)
  next if block.transactions.empty?

  satsleft = SatsCalculator.new.sats_left(block.height)
  uri = URI("http://satsleft_webserver:port/satsleft/#{satsleft}")
  req = Net::HTTP::Get.new(uri)
  req['Authorization'] = 'changeme'

  Net::HTTP.start(uri.hostname, uri.port) do |http|
    http.request(req)
  end

  Satsleft::TwitterBot.new(block_height: block.height, sats_left: from_calc).tweet

  break if data == "QUIT"
end

