# Fuzzy Like This
# ==============

# Author: Tim van de Langkruis <tim@maximum.nl> 
# Inspired by: Mereghost <marcello.rocha@gmail.com>


# Adds support for "fuzzy_like_this" and "fuzzt_like_this_field" queries in Tire DSL.

# It hooks into the Query class and inserts the fuzzy_like_this and fuzzy_like_this_field query types.


# Usage:
# ------

# Require the component:

#     require 'tire/queries/fuzzy_like_this'

# From that point on you should have the fuzzy_like_this (aliased to flt) and
# the fuzzy_like_this_field (aliased to flt_field) queries available.


# Example:
# -------

#     Tire.search 'articles' do
#       query do
#          fuzzy_like_this 'search for similar text'
#          fuzzy_like_this_field :field_name, 'similar text'
#       end
#     end

# For available options for these queries see:

# * <http://www.elasticsearch.org/guide/reference/query-dsl/flt-query.html>
# * <http://www.elasticsearch.org/guide/reference/query-dsl/flt-field-query.html>

#
require 'tire/queries/fuzzy_like_this/fuzzy_like_this'

Tire::Search::Query.class_eval do
  include Tire::Search::FuzzyLikeThis
end
