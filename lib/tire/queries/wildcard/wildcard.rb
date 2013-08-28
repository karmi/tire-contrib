module Tire
  module Search
    module Wildcard
      def wildcard(field, text, options = {})
        @value = {:wildcard => { field => { :value => text } } }
        @value[:wildcard][field].update(validate_wildcard_options(options))
        @value
      end

      private
      def validate_wildcard_options(options)
        valid_options = [:boost]
        options.delete_if { |key, value| !valid_options.member? key }
      end
    end
  end
end