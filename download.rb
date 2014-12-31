#!/usr/bin/env ruby

require 'rubygems'
require 'nokogiri'
require 'open-uri'

INDEX_PAGE = "http://community.livejournal.com/clinic_duty/12225.html"

(open(INDEX_PAGE) { |f| Nokogiri::HTML(f) }.css("table > tbody > tr > td > a")).each do |a|
  #Skip season links
  next if (a.css("b")).any?

  #Download a transcript
  season, episode = a.previous.previous.inner_text.strip.split(".")
  title = a.inner_text.strip
  url = a["href"]
  puts "Download %s.%s %s" % [season, episode, title]
  transcript = (open(url) { |f| Nokogiri::HTML(f) }.css("div.entryText"))[0].inner_html
  File.open("#{season}-#{episode}.html", "w") { |f|
    f.write('<html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8" /></head><body>')
    f.write(transcript)
    f.write('</body></html>')
  }
end
