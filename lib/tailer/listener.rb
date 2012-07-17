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
require 'eventmachine'
require 'shellwords'
require 'logger'

module Tailer
  class Listener
    attr_accessor :hosts, :files, :log, :output
    def initialize(options)
      @hosts = options[:hosts]
      @files = options[:files]
      @log = options[:log] || ::Logger.new(STDERR)
      Handler.output = options[:output] || STDOUT
      Handler.log = log
      @last_status = 0
    end

    def spawn(host)
      EventMachine.popen("ssh #{Shellwords.escape(host)} \"tail -q -F #{@files.map { |file| Shellwords.escape(file) }.join(' ')}\"", Handler)
    end

    def execute
      begin
        @t_start = Time.now.to_f
        Handler.t_start = Time.now.to_f
        Handler.bytes = 0
        Handler.last_status = 0
        EventMachine.run do
          @hosts.each do |host|
            spawn(host)
          end
        end
      rescue Errno::EPIPE => e
        @log.info "Exiting..."
      rescue Interrupt => e
        @log.info "Exiting..."
      end
    end
  end

  class Handler < EM::Connection
    @@log = Logger.new(STDERR)
    @@output = STDOUT
    @@bytes = 0
    @@last_status = 0
    @@t_start = nil

    def self.output
      @@output
    end

    def self.output=(output)
      @@output = output
    end

    def self.bytes
      @@bytes
    end

    def self.bytes=(bytes)
      @@bytes = bytes
    end

    def self.log
      @@log
    end

    def self.log=(log)
      @@log=log
    end

    def self.last_status 
      @@last_status
    end

    def self.last_status=(last_status)
      @@last_status = last_status
    end

    def self.t_start
      @@t_start
    end

    def self.t_start=(t_start)
      @@t_start = t_start
    end

    def initialize()
      super
    end

    def receive_data data
      Handler.bytes = Handler.bytes + data.length
      if (Handler.bytes - Handler.last_status > 10000)
        elapsed = Time.now.to_f - Handler.t_start
        Handler.log.debug "#{Handler.bytes} bytes read; #{Handler.bytes/elapsed} B/s" 
        Handler.last_status = Handler.bytes
      end
      Handler.output.print data
    end  

    def unbind
      Handler.log.debug "exit status (#{get_status.exitstatus})"
    end
  end

end