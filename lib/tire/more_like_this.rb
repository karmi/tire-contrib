# More Like This
# ============
#
# Author: Mereghost <marcello.rocha@gmail.com>
#
#
# Adds support for more like this queries for Tire.
#
# It hooks into the Query class and inserts the more_like_this and more_like_this_field query types.
#
# Usage:
# ------
#
# Require the component:
#
#     require 'tire/more_like_this'
#
# From that point on you should have the more_like_this (aliased to mlt) and
# the more_like_this_field (aliased to mlt_field) queries available.
#
# Example:
#   tire.search 'articles' do
#     query do
#        more_like_this 'search for similar text'
#        more_like_this_field :field_name, 'similar text'
#     end
#   end
#
#  For available options for these queries see the relevant ES documentations
#

require 'tire/more_like_this/more_like_this'

Tire::Search::Query.class_eval do
  include Tire::Search::MoreLikeThis
end
