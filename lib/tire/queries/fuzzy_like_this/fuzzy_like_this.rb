module Tire
  module Search
    module FuzzyLikeThis
      def fuzzy_like_this(like_text, options = {})
        @value = {:flt => {:like_text => like_text}}
        @value[:flt].update(validate_fuzzy_like_this_options(options))
        @value
      end

      def fuzzy_like_this_field(field, like_text, options = {})
        @value = {:flt_field => {field => {:like_text => like_text}}}
        # :fields is invalid in this context. Better than doing some kind of meta-black magic.
        options.delete(:fields)
        @value[:flt_field][field].update(validate_fuzzy_like_this_options(options))
        @value
      end

      alias_method :flt, :fuzzy_like_this
      alias_method :flt_field, :fuzzy_like_this_field

      private
      def validate_fuzzy_like_this_options(options)
        valid_options = [:fields, :ingore_tf, :max_query_terms, :min_similarity, :prefix_length, :boost, :analyzer]
        options.delete_if { |key, value| !valid_options.member? key }
      end
    end
  end
end