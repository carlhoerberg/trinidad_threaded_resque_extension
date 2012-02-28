require 'resque'

module Resque
  class Worker
    # if we let resque trap signals trinidad cannot ever be stopped
    alias :old_register_signal_handlers :register_signal_handlers
    def register_signal_handlers
    end

    def to_s
      @to_s ||= "#{hostname}:#{Process.pid}-#{Thread.current.object_id}:#{@queues.join(',')}"
    end
  end
end
