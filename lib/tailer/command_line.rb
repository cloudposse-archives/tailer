#
# Tailer - A utility to stream files over SSH
# Copyright (C) 2012 Erik Osterman <e@osterman.com>
# 
# This file is part of Tailer.
# 
# Tailer is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# Tailer is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with Tailer.  If not, see <http://www.gnu.org/licenses/>.
#
require 'optparse'
require 'logger'

module Tailer
  class MissingArgumentException < Exception; end

  class CommandLine
    attr_accessor :downloader
    def initialize
      @options = {}
      begin
        @optparse = OptionParser.new do |opts|
          opts.banner = "Usage: #{$0} options"
          
         
          @options[:output] = STDOUT
          opts.on( '--output FILE', 'Send all recieved data to FILE (defaults to STDOUT)') do |file|
            @options[:output] = File.new(file, 'a+')
          end
         
          @options[:hosts] = []
          opts.on( '--host HOST', 'Host to connect to via SSH' ) do |host|
            @options[:hosts] << host
          end

          @options[:files] = []
          opts.on( '--file FILE', 'File to tail' ) do |file|
            @options[:files] << file
          end

          @options[:log_level] = Logger::INFO
          opts.on( '--log-level LEVEL', 'Logging level' ) do|level|
            @options[:log_level] = Logger.const_get level.upcase
          end

          opts.on( '-V', '--version', 'Display version information' ) do
            puts "Tailer #{Tailer::VERSION}"
            puts "Copyright (C) 2012 Erik Osterman <e@osterman.com>"
            puts "License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>"
            puts "This is free software: you are free to change and redistribute it."
            puts "There is NO WARRANTY, to the extent permitted by law."
            exit
          end

          opts.on( '-h', '--help', 'Display this screen' ) do
            puts opts
            exit
          end
        end

        @optparse.parse!

        raise MissingArgumentException.new("Missing --host argument") if @options[:hosts].length == 0
        raise MissingArgumentException.new("Missing --file argument") if @options[:files].length == 0

        @listener = Listener.new(@options)
      rescue MissingArgumentException => e
        puts e.message
        puts @optparse
        exit (1)
      end
    end

    def execute
      @listener.execute
    end

  end
end