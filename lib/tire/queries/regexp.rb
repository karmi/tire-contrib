# Regexp
# ==============
#
# Author: Curtis Hatter <mitchell.hatter@gmail.com>
#
#
# Adds support for "regexp" queries in Tire DSL.
#
# It hooks into the Query class and inserts the regexp query type.
#
#
# Usage:
# ------
#
# Require the component:
#
#     require 'tire/queries/regexp'
#
# From that point on you should have the regexp query available.
#
#
# Example:
# -------
#
#     Tire.search 'articles' do
#       query do
#         regexp "name.first", 's.*y'
#       end
#     end
#
#     Tire.search 'articles' do
#       query do
#         regexp "name.first", 's.*y', boost: 1.2, flags: [:intersection, :complement, :empty]
#       end
#     end
#
# For more about this query:
#
# * <http://www.elasticsearch.org/guide/reference/query-dsl/regexp-query/>
#
#
require 'tire/queries/regexp/regexp'

Tire::Search::Query.class_eval do
  include Tire::Search::Regexp
end
