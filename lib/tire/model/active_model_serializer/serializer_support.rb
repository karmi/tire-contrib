module Tire
  module Model
    module SerializerSupport

      extend ActiveSupport::Concern

      if "".respond_to?(:safe_constantize)
        def tire_active_model_serializer
          "Tire#{self.class}Serializer".safe_constantize
        end
      else
        def tire_active_model_serializer
          begin
            "Tire#{self.class}Serializer".constantize
          rescue NameError => e
            raise unless e.message =~ /uninitialized constant/
          end
        end
      end

      # Returns a model serializer for this object considering its namespace.
      #
      def active_model_serializer
        self.tire_active_model_serializer || self.class.active_model_serializer
      end

    end
  end
end
