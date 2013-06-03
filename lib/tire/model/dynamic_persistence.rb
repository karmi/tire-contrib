# Dynamic Persistence
# ===================
#
# Author: Dave Kinkead <dave@kinkead.com.au>
# Contributors:
# Matthew Hirst (SixiS)
#
# Adds support for dynamic persistence to Tire::Model::Persistence,
# so explicit declarations of `property :attr_name` are not required.
#
#
# Usage:
# ------
#
# Require the component:
#
#     require 'tire/model/dynamic_persistence'
#
# Example:
# -------
#
#     class Author
#       include Tire::Model::Persistence
#       include Tire::Model::DynamicPersistence
#     end
#
#     author = Author.new :name => 'Inigo Montoya',
#                         :books => ['The Pragmatic Swordfighter', 'Revenge: Best Served Cold']
#
#     author.name
#     # => 'Inigo Montoya'
#
#     author.rating = 5
#
#     author.rating
#     # => 5
#
#     author.update_attributes({publisher: 'GoodBooks', home_town: 'Worcester'})
#
#     author.publisher
#     # => 'GoodBooks'
#     author.home_town
#     # => 'Worcester'
#
require 'tire/model/dynamic_persistence/dynamic_persistence'
