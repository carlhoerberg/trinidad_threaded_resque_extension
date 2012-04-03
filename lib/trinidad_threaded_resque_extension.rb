require 'resque'
require 'trinidad'
require_relative "trinidad_threaded_resque_extension/version"
require_relative "trinidad_threaded_resque_extension/lifecycle_listener"

module Trinidad
  module Extensions
    class ThreadedResqueWebAppExtension < WebAppExtension
      def configure(tomcat, app_context)
        app_context.add_lifecycle_listener(ThreadedResque::LifecycleListener.new(@options))
      end
    end
  end
end

