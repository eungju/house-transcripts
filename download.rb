#!/usr/bin/env ruby

require 'rubygems'
require 'hpricot'
require 'open-uri'

INDEX_PAGE = "http://community.livejournal.com/clinic_duty/12225.html"

(open(INDEX_PAGE) { |f| Hpricot(f) }/"table > tbody > tr > td > a").each do |a|
  #Skip season links
  next if (a/"b").any?

  #Download a transcript
  season, episode = a.previous.previous.inner_text.strip.split(".")
  title = a.inner_text.strip
  url = a["href"]
  puts "Download %s.%s %s" % [season, episode, title]
  transcript = (open(url) { |f| Hpricot(f) }/"body div#content-wrapper div.b-singlepost > div")[2].inner_html
  File.open("#{season}-#{episode}.html", "w") { |f|
    f.write('<html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8" /></head><body>')
    f.write(transcript)
    f.write('</body></html>')
  }
end
