# Trinidad Threaded Resque Extension

Run Resque workers, threaded, within the Trinidad process. 

Inspiration: https://github.com/trinidad/trinidad_resque_extension/

## Installation

Add this line to your application's Gemfile:

    gem 'trinidad_threaded_resque_extension'

And then execute:

    $ bundle

Then configure it via config/trinidad.rb:

    require 'bundler/setup'
    Trinidad.configure |config|
      ...
      config.extensions = {
        threaded_resque = {
          setup: './config/setup_resque_workers', # will be required before starting the workers
          queues: {
            # syntax: "queue name: number of workers"
            # the "all" queue is an alias for "*"
            # default is "all: 1"
            all: 3,
            high: 2,
            low: 1
          }
        }
      }

## Usage

Start trinidad and enjoy the low memory usage while having high concurrency.

Note that becasue JRuby can't fork you want to have well behaved workers, watch out for memory leakage.. 

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
