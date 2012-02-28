module Trinidad
  module Extensions
    module ThreadedResque
      class LifecycleListener
        include Trinidad::Tomcat::LifecycleListener
        attr_accessor :options, :workers, :threads

        def initialize(options = {})
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
          @workers = create_workers
          @threads = create_threads
        end

        def stop_workers
          @workers.each { |w| w.shutdown }
          @threads.each { |t| t.join }
        end

        private 
        def create_workers
          queues = @options[:queues] || { :all => 1 }
          queues.map do |queue, count|
            queue = '*' if queue.to_s == 'all'
            count.to_i.times.map do 
              worker = Resque::Worker.new(queue)
              worker.cant_fork = true # fork is a noop in jruby
              worker
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
