module Tire
  module Namespace
    module Index
      def self.included klass
        klass.class_eval do

          # Redefine the `initialize` method to prefix the index name with the namespace
          #
          def initialize(name, &block)
            @name = Tire::Configuration.namespace ? "#{Tire::Configuration.namespace}-#{name}" : name
            block.arity < 1 ? instance_eval(&block) : block.call(self) if block_given?
          end

        end
      end
    end
  end
end
