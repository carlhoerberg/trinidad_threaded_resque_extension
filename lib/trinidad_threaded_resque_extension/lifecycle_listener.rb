require_relative "worker"

module Trinidad
  module Extensions
    module ThreadedResque
      class LifecycleListener
        include Trinidad::Tomcat::LifecycleListener
        attr_accessor :options, :workers, :threads

        def initialize(options = {})
          @options = options
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
          pre_require
          @workers = create_workers
          @threads = create_threads
        end

        def stop_workers
          @workers.each { |w| w.shutdown } if @workers
          @threads.each { |t| t.join } if @threads
        end

        private 
        def pre_require
          if @options[:require]
            require @options[:require] 
          else
            raise "You probably want to require something before starting workers"
          end
        end

        def create_workers
          queues = @options[:queues] || { '*' => 1 }
          queues.map do |queue, count|
            count.to_i.times.map do 
              ThreadedResque::Worker.new(queue.to_s)
            end
          end.flatten
        end

        def create_threads
          @workers.map do |w|
            Thread.new do
              w.work
            end
          end
        end
      end
    end
  end
end
