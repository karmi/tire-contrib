module Tire
  module Model

    module NewRelic

      def self.included(base)
        base.class_eval do
          ::NewRelic::Agent.logger.debug "Installing NewRelic instrumentation for #{self}"

          include ::NewRelic::Agent::MethodTracer
          add_method_tracer :update_index, 'Search/#{self.class.name}/update_index'

          class << self
            include ::NewRelic::Agent::MethodTracer
            add_method_tracer :search, 'Search/#{self}/search'
           end
        end
      end

    end

  end
end
