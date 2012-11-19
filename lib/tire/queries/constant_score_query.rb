require 'tire/queries/constant_score_query/constant_score_query'

Tire::Search::Query.class_eval do
  include Tire::Search::ConstantScoreQuery
end