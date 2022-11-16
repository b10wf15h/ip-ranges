# require ipaddr lib
require "ipaddr"

# read and parse list of the ips
read_ips = File.read('data/list_test').split("\n")

ips = []
# convert Ips to the integer values
read_ips.each do |ip|
  ips << IPAddr.new(ip).to_i
end

# sort list
ips.sort!

# create a ranges of integers
prev = ips[0]
ranges = ips.slice_before { |ip_integer|
  prev, prev2 = ip_integer, prev
  prev2 + 1 != ip_integer
}.map{|b,*,c| c ? (b..c) : b }

# create a ranges of IPs
list = []
ranges.each do |range|
  unless range.class == Range
    list << IPAddr.new(range, Socket::AF_INET).to_s
  else
    first = IPAddr.new(range.first, Socket::AF_INET).to_s
    last = IPAddr.new(range.last, Socket::AF_INET).to_s

    list << first + '-' + last
  end
end

# print list
puts list.join("\n")