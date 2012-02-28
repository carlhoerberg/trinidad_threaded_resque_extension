require 'resque'

module Trinidad
  module Extensions
    module ThreadedResque
      class Worker < Resque::Worker
        def initialize(*queues)
          super(*queues)
          @cant_fork = true
        end

        # we can't let resque trap signal
        def register_signal_handlers
        end

        #override to_s and separate different workers by there thread id
        def to_s
          @to_s ||= "#{hostname}:#{Process.pid}-#{Thread.current.object_id}:#{@queues.join(',')}"
        end
      end
    end
  end
end
