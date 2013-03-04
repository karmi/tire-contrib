# Dynamic Persistence
# ===================
#
# Author: Dave Kinkead <dave@kinkead.com.au>
#
#
# Adds support for dynamic persistence to Tire::Model::Persistence so that explict 
#   declarations of 'property :attr_name' are not required
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
#
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
#
require 'tire/model/dynamic_persistence/dynamic_persistence'