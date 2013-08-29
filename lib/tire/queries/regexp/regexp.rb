module Tire
  module Search
    module Regexp
      def regexp(field, text, options = {})
        @value = {:regexp => { field => { value: text } } }
        @value[:regexp][field].update(validate_regexp_options(options))
        @value
      end

      private
      def validate_regexp_options(options)
        valid_options = [:boost, :flags]
        options.delete_if { |key, value| !valid_options.member? key }
        
        options[:flags] = validate_regexp_flags(options[:flags]) if options.member?(:flags)
        options
      end
      
      def validate_regexp_flags(flags = [])
        valid_flags = [:all, :anystring, :automaton, :complement, :empty, :intersection, :interval, :none]
        
        if flags.is_a?(Array)
          (flags.map { |i| i.downcase.to_sym } & valid_flags).map { |i| i.to_s.upcase }.join('|')
        else
          flags.to_s.upcase if valid_flags.member?(flags)
        end
      end
    end
  end
end
