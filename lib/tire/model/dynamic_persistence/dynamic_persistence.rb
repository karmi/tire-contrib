require 'tire'

module Tire
  module Model
    module DynamicPersistence

      # Overrides the initializer in Tire::Model::Persistence to allow
      #   dynamic creation of attributes without the need to
      #   declare them with `property :name`
      #
      def initialize(attrs={})
        set_attributes(attrs)
        super attrs
      end

      def set_attributes(attrs={})
        attrs.each do |attr, value|
          set_attribute(attr, value)
        end
      end

      def set_attribute(attribute, value)
        # => call Tire's property method if it's declared for this attribute
        self.class.property attribute unless self.class.property_types.keys.include? attribute
        # => set instance variable for this attribute
        instance_variable_set("@#{attribute}", value)
      end
    end
  end
end
