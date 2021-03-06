#!/usr/bin/env ruby

require 'rubygems'
require 'nokogiri'

character = "House"
character = ARGV[0] if ARGV.length == 1
pattern = Regexp.compile("^\\s*#{character}\\s*:.+$", Regexp::IGNORECASE)

for episode in Dir.glob('?-??.html').shuffle
  lines = open(episode) { |f|
    Nokogiri::HTML(f).xpath("//*/text()").select { |node|
      node.text? and pattern.match(node.content)
    }
  }.shuffle
  unless lines.empty?
    puts lines.shuffle[0]
    break
  end
end
