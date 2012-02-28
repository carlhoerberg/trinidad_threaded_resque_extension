require 'resque'
require 'trinidad'
require_relative "trinidad_threaded_resque_extension/version"
require_relative "trinidad_threaded_resque_extension/lifecycle_listener"

module Trinidad
  module Extensions
    class ThreadedResqueServerExtension < ServerExtension
      def configure(tomcat)
        tomcat.host.add_lifecycle_listener(ThreadedResque::LifecycleListener.new(@options))
      end
    end
  end
end

