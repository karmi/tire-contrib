module Tire
  module Rails
    class Railtie < ::Rails::Railtie

      initializer "tire.initializer" do |app|
        require 'tire/rails/logger/instrumentation'
        require 'tire/rails/logger/log_subscriber'
        require 'tire/rails/logger/controller_runtime'

        # Inject instrumentation into Tire::Search
        #
        Tire::Search::Search.module_eval do
          include Tire::Rails::Instrumentation
        end

        # Hook into Rails controllers to provide logging
        #
        ActiveSupport.on_load(:action_controller) do
          include Tire::Rails::ControllerRuntime
        end
      end

    end
  end
end
