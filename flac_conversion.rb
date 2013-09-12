#!/usr/bin/env ruby
#
# Copyright 2013 David Frey
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

require 'find'

def flac_to_mp3(input, output, bitrate = '320k')
  `ffmpeg -i '#{input}' -ab #{bitrate} -ac 2 -ar 48000 '#{output}'`
end

path_to_search = nil
until path_to_search do
  print "Which directory would you like to convert?: "
  path_to_search =  gets.chomp

  if Dir.exists?(path_to_search)
    Dir.chdir(path_to_search)
  else
    path_to_search = nil
    puts "That directory doesn't exist. Try another."
  end
end

flac_file_paths = []
Find.find('.') do |path|
  flac_file_paths << path if path =~ /.*\.flac$/
end

format = nil
until format do
  print "Would you like the audio as MP3s? (y/n): "
  if gets.strip.downcase == 'y'
    format = :mp3
  end
end

case format
when :mp3
  Dir.mkdir('mp3') unless Dir.exists?('mp3')

  print "What bitrate would you like? (e.g. 320k): "
  bitrate = gets.strip.downcase

  flac_file_paths.each do |flac_path|
    file_name = flac_path.match(/.*\/(.*).flac/)[1]
    mp3_path = "mp3/#{file_name}.mp3"

    flac_to_mp3(flac_path, mp3_path, bitrate)
  end
end