module Tire
  module Search
    module CustomFiltersScore
      
      def custom_filters_score(&block)
        @custom_filters_score = CustomFiltersScoreQuery.new
        block.arity < 1 ? @custom_filters_score.instance_eval(&block) : block.call(@custom_filters_score) if
          block_given?
        @value[:custom_filters_score] = @custom_filters_score.to_hash
        @value
      end
      
      class CustomFiltersScoreQuery
        class CustomFilter
          def initialize(&block)
            @value = {}
            block.arity < 1 ? self.instance_eval(&block) : block.call(self) if block_given?
          end

          def filter(type, *options)
            @value[:filter] = Filter.new(type, *options).to_hash
            @value
          end

          def boost(value)
            @value[:boost] = value
            @value
          end

          def script(value)
            @value[:script] = value
            @value
          end

          def to_hash
            @value
          end

          def to_json
            to_hash.to_json
          end
        end

        def initialize(&block)
          @value = {}
          block.arity < 1 ? self.instance_eval(&block) : block.call(self) if block_given?
        end

        def query(options={}, &block)
          @value[:query] = Query.new(&block).to_hash
          @value
        end

        def filter(&block)
          custom_filter = CustomFilter.new
          block.arity < 1 ? custom_filter.instance_eval(&block) : block.call(custom_filter) if block_given?
          @value[:filters] ||= []
          @value[:filters] << custom_filter.to_hash
          @value
        end

        def score_mode(value)
          @value[:score_mode] = value
          @value
        end

        def to_hash
          @value[:filters] ? 
          @value : 
          @value.merge(:filters => [CustomFilter.new{ filter(:match_all); boost(1) }.to_hash]) # Needs at least one filter
        end

        def to_json
          to_hash.to_json
        end
      end
    end
  end
end