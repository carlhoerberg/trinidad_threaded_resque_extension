require 'resque'
require "trinidad_threaded_resque_extension/version"
require "trinidad_threaded_resque_extension/resque_disable_signal_handlers"

module Trinidad
  module Extensions
    module ThreadedResque

      class ThreadedResqueLifecycleListner
        include Trinidad::Tomcat::LifecycleListener
        def initialize(options)
          @options = options
          require @options[:setup] if @options[:setup]
        end

        def lifecycleEvent(event)
          case event.type
          when Trinidad::Tomcat::Lifecycle::BEFORE_START_EVENT
            start_workers
          when Trinidad::Tomcat::Lifecycle::BEFORE_STOP_EVENT
            stop_workers
          end
        end

        def start_workers
          queues = @options[:queues] || { 'all' => 1 }
          @workers = queues.map do |queue, count|
            queue = '*' if queue == 'all'
            count.to_i.times.map do 
              worker = Resque::Worker.new(queue)
              worker.cant_fork = true # fork is a noop in jruby
              Thread.new do
                worker.work
              end
            end
          end.flatten
        end

        def stop_workers
          @workers.each { |w| w.shutdown! }
        end
      end
    end
  end
end

