# require ipaddr lib
require "ipaddr"
require 'optparse'

# init options
options = {}

# init args
arg = OptionParser.new
arg.banner = 'Ip Ranges'
arg.separator ''
arg.separator 'Create ip ranges from ip list'
arg.separator ''
arg.separator 'Usage: range [options]'
arg.separator ''
arg.separator 'Options:'
arg.on('-p', '--path path', 'Path to the IP list file (required).') { |value| options[:path]   = value }
arg.separator ''

arg.separator 'Other options:'
arg.on('-h', '--help')    { puts arg.to_s; exit }
arg.on('-v', '--version') { puts version; exit }
arg.separator ''

# parse arguments
begin
  arg.parse!(ARGV)
rescue OptionParser::MissingArgument
  puts "Please specify valid arguments."
  exit(1)
end

# set a mandatory options
mandatory_args = [:path]

# raise a exception in case mandatory fields are missing
unless mandatory_args.select{ |param| options[param].nil? }.empty?
  puts arg.to_s
  exit(1)
end

# read and parse list of the ips
read_ips = File.read(options[:path]).split("\n")

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
