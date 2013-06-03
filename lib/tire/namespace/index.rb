module Tire
  module Namespace
    module Index
      def self.included klass
        klass.class_eval do
          alias_method :original_name, :name

          define_method :name do
            Tire::Configuration.namespace ? "#{Tire::Configuration.namespace}-#{@name}" : @name
          end
        end
      end
    end
  end
end
