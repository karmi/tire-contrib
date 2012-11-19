module Tire
  module Search
    module ConstantScoreQuery

      def constant_score(&block)
        @constant_score = ConstantScoreQuery.new
        block.arity < 1 ? @constant_score.instance_eval(&block) : block.call(@constant_score) if block_given?
        @value[:constant_score] = @constant_score.to_hash
        @value
      end

      class ConstantScoreQuery
        def initialize(&block)
          @value = {}
          block.arity < 1 ? self.instance_eval(&block) : block.call(self) if block_given?
        end

        def boost(value)
          @value[:boost] = value
          @value
        end

        def query(options={}, &block)
          @value[:query] = Query.new(&block).to_hash
          @value
        end

        def filter(type, *options)
          @value[:filter] ||= {}
          @value[:filter][:and] ||= []
          @value[:filter][:and] << Filter.new(type, *options).to_hash
          @value
        end

        def to_hash
          @value
        end

        def to_json
          to_hash.to_json
        end
      end
    end
  end
end