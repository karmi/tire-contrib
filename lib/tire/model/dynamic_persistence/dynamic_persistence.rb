require 'tire'

module Tire
  module Model
    module DynamicPersistence
      
      # Overrides the initializer in Tire::Model::Persistence to allow
      #   dynamic creation of attributes without the need to 
      #   declare them with 'property :name'
      def initialize(attrs={})
        attrs.each do |attr, value|
          # => call Tire's property method if it hasn't been set
          self.class.property attr unless self.class.property_types.keys.include? attr
          # => set instance variable
          instance_variable_set("@#{attr}", value) 
        end
        super attrs             
      end
    end
  end
end