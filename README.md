# Tailer

Tailer is a utility to stream files over SSH

## Installation

Add this line to your application's Gemfile:

    gem 'tailer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tailer

## Usage

    Usage: tailer options
            --output FILE                Send all recieved data to FILE (defaults to STDOUT)
            --host HOST                  Host to connect to via SSH
            --file FILE                  File to tail
            --log-level LEVEL            Logging level
        -V, --version                    Display version information
        -h, --help                       Display this screen

## Examples

  Send all data from /var/log/messages on host1, host2, and host3 to STDOUT
  
    tailer --host host1 --host host2 --host host3 --file /var/log/messages

  Send all data from /var/log/messages on host1, host2, and host3 to /tmp/test.log
  
    tailer --host host1 --host host2 --host host3 --file /var/log/messages --output /tmp/test.log

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
