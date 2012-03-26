module Tire
  module Search
    module MoreLikeThis
      def more_like_this(like_text, options = {})
        @value = {:mlt => {:like_text => like_text}}
        @value[:mlt].update(validate_more_like_this_options(options))
        @value
      end

      def more_like_this_field(field, like_text, options = {})
        @value = {:mlt_field => {field => {:like_text => like_text}}}
        # :fields is invalid in this context. Better than doing some kind of meta-black magic.
        options.delete(:fields)
        @value[:mlt_field][field].update(validate_more_like_this_options(options))
        @value
      end

      alias_method :mlt, :more_like_this
      alias_method :mlt_field, :more_like_this_field

      private
      def validate_more_like_this_options(options)
        valid_options = [:fields, :percent_terms_to_match, :min_term_freq,
                         :max_query_terms, :stop_words, :min_doc_freq, :max_doc_freq,
                         :min_word_len, :max_word_len, :boost_terms, :boost, :analyzer]
        options.delete_if { |key, value| !valid_options.member? key }
      end
    end
  end
end