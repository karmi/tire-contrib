# Indices
# ==============
#
# Author: Wuron <chepurnoy.aleksandr@gmail.com>
#
# Adds support for "indices" query in Tire DSL.
#
# It hooks into the Query class and inserts the indices query type.
#
#
# Usage:
# ------
#
# Require the component:
#
#     require 'tire/queries/indices'
#
# From that point on you should have the indices query available.
#
#
# Example:
# -------
#
#     Tire.search 'articles' do
#       query do
#         indices ['index1', 'index2'] do
#           query do
#             term 'tag', 'wow'
#           end
#           no_match_query do
#             term 'tag', 'kow'
#           end
#         end
#       end
#     end
#
# no_match_query can also have string value of “none” (to match no documents),
# and “all” (to match all).
#
#
# For available options for these queries see:
#
# <http://www.elasticsearch.org/guide/reference/query-dsl/indices-query/>
#
#
require 'tire/queries/indices/indices'

Tire::Search::Query.class_eval do
  include Tire::Search::Indices
end
