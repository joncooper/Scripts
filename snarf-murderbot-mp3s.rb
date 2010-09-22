# This guy Chrissy Murderbot made a "year of mixtapes", one genre per week.
# Hit the feed, parse it, build an index HTML file, and download all the MP3s.
#
# Jon Cooper <jon.cooper@gmail.com>
# 30 July 2010

require 'open-uri'
require 'rubygems'
require 'nokogiri'

# Grab the feed which contains URLs for each week's mp3 file

feedurl = "http://feeds.feedburner.com/myyearofmixtapes"
filename = "murderbot-weekly-mixtapes.html"

print "Grabbing feed..."
STDOUT.flush
feed = Nokogiri::XML(open(feedurl))
puts "done."

# Print all titles and descriptions to a file

print "Writing titles, descriptions, and links to #{filename}..."
STDOUT.flush

# Pull out a Nokogiri NodeSet from the XML

items = feed.xpath("//item")

# Parse, write HTML, then grab files

files_to_grab = []

open(filename, 'w') do |out|
  
  out.puts "<html><head><title>murderbot weekly mixtapes</title></head>"
  out.puts "<body>"
  
  # Iterate over items from the feed, pull out details, emit to file, add to download list
  
  items.each do |item|
    
    title = item.at("title").text
    description = item.at("description").text
    url = item.at("enclosure").attribute("url").text
    localurl = url.strip.sub(/(http:).*\/(.*)/, 'file://./\2')
    
    files_to_grab << url
    
    out.puts "<h2>#{title}</h2>"
    out.puts "<p>#{description}</p>"
    out.puts "<a href=\"#{localurl}\">#{localurl}</a>"
    
  end
  
  out.puts "</body>"
  out.puts "</html>"
  
end

puts "done."

print "Grabbing MP3 files..."
STDOUT.flush

# Download files using wget or curl or just print out for testing

files_to_grab.each do |url|
#  system "wget -nc -c #{url}"
#  system "curl -O #{url}"
  puts url
end

puts "done."

