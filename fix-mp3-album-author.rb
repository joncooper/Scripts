#
#
# Jon Cooper <jon.cooper@gmail.com>
# 22 September 2010
#
# Notes on libraries -
# 
# MP3 library:            http://ruby-mp3info.rubyforge.org/
# Alternate MP3 library:  http://www.hakubi.us/ruby-taglib/
# And another one:        http://id3lib-ruby.rubyforge.org/ 
#
# Dear god, why so many getopt libraries?
# I tried optparse (poorly documented, heavyweight), main (wonky, a DSL, really?)
# Settled on Trollop, which is minimal feeling
#

require 'rubygems'
require 'mp3info'
require 'trollop'

###
### Methods
###

#
# Ganky method to verify that we can parse ID3 tags from a file
# 
def can_parse_id3?(filename)
  begin
    trash = Mp3Info.open(filename)
    return true
  rescue
    return false
  end
end

#
# Glob a filespec into an array. 
# Keep only elements that are MP3 files.
#
def glob_mp3_files_from_filespec(filespec)
  files = Dir[filespec]
  files.reject! { |fn| File.directory?(fn) }
  files.reject! { |fn| !(can_parse_id3?(fn)) } 
  return files
end
  
#
# Dump all ID3 information pretty-printed to stdout
#

def dump(filename)
  puts "Handling #{filename}"
  if (File.directory?(filename))
    puts "Skipping directory #{filename}."
  end
  begin 
    puts YAML::dump(Mp3Info.open(filename))
  rescue Mp3InfoError
    puts "Could not parse #{filename} for ID3 tags, skipping."
  end
end

#
# Retag files, setting iTunes' Album Artist field (ID3v2 TPE2).
#

def retag_album_artist(filename, album_artist_tag)
  Mp3Info.open(filename) do |mp3file|
    print "Retagging #{filename}..."
    STDOUT.flush
    if (mp3file.tag2.TPE2)
      puts "oops!"
      puts "Found existing Album Artist tag: #{mp3file.tag2.TPE2}. Skipping file."
      return
    end
    mp3file.tag2.TPE2 = album_artist_tag
    puts "done."
  end
end

###
### Main entry point.
###

opts = Trollop::options do
  banner <<-EOT
  
Usage:
  ruby fix-mp3-album-author.rb [options] <filenames or filespecs>+
  
where [options] are:
EOT
  opt :dump, "Dump ID3 tags and return; will not retag anything."
  opt :tag, "Tag to set on Album Artist ID3v2 field.", :type=>String
end

# The only thing left in argv is the stuff after the options, which is a list of either filenames or filespecs

mp3_files = ARGV.collect { |fn| glob_mp3_files_from_filespec(fn) }
mp3_files.flatten!

if (mp3_files.length < 1)
  puts "No files or filespecs passed!"
  exit(-1)
end

if (opts[:dump])
  mp3_files.each { |fn| dump(fn) }
  exit(0)
end

mp3_files.each { |fn| retag_album_artist(fn, opts[:tag]) }
exit(0)



