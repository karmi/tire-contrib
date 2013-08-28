# Wildcard
# ==============
#
# Author: Curtis Hatter <mitchell.hatter@gmail.com>
#
#
# Adds support for "wildcard" queries in Tire DSL.
#
# It hooks into the Query class and inserts the wildcard query type.
#
#
# Usage:
# ------
#
# Require the component:
#
#     require 'tire/queries/wildcard'
#
# From that point on you should have the wildcard query available.
#
#
# Example:
# -------
#
#     Tire.search 'articles' do
#       query do
#         wildcard :field_name, 'ki*y'
#       end
#     end
#
#     Tire.search 'articles' do
#       query do
#         wildcard :field_name, 'ki*y', boost: 2.0
#       end
#     end
#
# For more about this query:
#
# * <http://www.elasticsearch.org/guide/reference/query-dsl/wildcard-query/>
#
#
require 'tire/queries/wildcard/wildcard'

Tire::Search::Query.class_eval do
  include Tire::Search::Wildcard
end
