OVERVIEW
========

This is a dumping ground for scripts that I wrote to do a one-off task, but that other folks might care about.

### fix-mp3-album-author.rb

This script is used to set an 'Album Author' ID3v2 tag on MP3 files, in bulk. When I get a mixtape from someone, or a bunch of mixtapes, and the tracks are individually tagged with their original album and artist, it borks both the 'Album' and 'Artist' views on my car stereo. I understand it borks iTunes as well. This will fix that kind of problem.

You'll need the gems ruby-mp3info and trollop. They can be installed with

	gem install ruby-mp3info
	gem install trollop
	
Then you can do something like

	ruby fix-mp3-album-author.rb -t 'Album artist tag to use' <filename 1> <filename 2> ... <filename N>
	
### snarf-murderbot-mp3s.rb

This script can be used to grab all of Chrissy Murderbot's 'Year of Mixtapes' MP3 files. It's a brief introduction to parsing HTML with Nokogiri. You'll need the Nokogiri gem:

	gem install nokogiri
	
Then just run the script, and it will emit a list of URIs for the MP3 files. If you wish, change the commented out lines of code to use one of curl or wget to grab them directly.

