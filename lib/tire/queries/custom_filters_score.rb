# Custom Filters Score
# ==============
#
# Author: Jerry Luk <jerryluk@gmail.com>
#
#
# Adds support for "custom_filters_score" queries in Tire DSL.
#
# It hooks into the Query class and inserts the custom_filters_score query types.
#
#
# Usage:
# ------
#
# Require the component:
#
#     require 'tire/queries/custom_filters_score'
#
# Example:
# -------
#
#     Tire.search 'articles' do
#       query do
#         custom_filters_score do
#           query { term :title, 'Harry Potter' }
#           filter do
#             filter :match_all
#             boost 1.1
#           end
#           filter do
#             filter :term, :author => 'Rowling',
#             script '_score * 2.0'
#           end
#           score_mode 'total'
#         end
#       end
#     end
#
# For available options for these queries see:
#
# * <http://www.elasticsearch.org/guide/reference/query-dsl/custom-filters-score-query.html>
#
#
require 'tire/queries/custom_filters_score/custom_filters_score'

Tire::Search::Query.class_eval do
  include Tire::Search::CustomFiltersScore
end
