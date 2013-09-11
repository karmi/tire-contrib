module Tire
  module Search
    module Indices
      def indices(indices = [], &block)
        @indices_query ||= IndicesQuery.new indices
        block.arity < 1 ? @indices_query.instance_eval(&block) : block.call(@indices_query) if block_given?
        @value[:indices] = @indices_query.to_hash
        @value
      end

      class IndicesQuery
        def initialize(indices = [], &block)
          @indices_array = indices
          @value   = {}
          block.arity < 1 ? self.instance_eval(&block) : block.call(self) if block_given?
        end

        def query(&block)
          @value[:query] = Query.new(&block).to_hash
          @value
        end

        def no_match_query(string_value = nil, &block)
          @value[:no_match_query] = if string_value
            string_value
          else
            Query.new(&block).to_hash
          end
          @value
        end

        def to_hash
          {:indices => @indices_array}.merge(@value)
        end
      end
    end
  end
end
