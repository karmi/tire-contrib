# Example class with Elasticsearch persistence in index `persistent_articles`
#
# The `index` is `persistent_articles`
#
require 'tire/model/dynamic_persistence'

class PersistentArticleInIndex

  include Tire::Model::Persistence
  include Tire::Model::DynamicPersistence

  property :title
  property :published_on
  property :tags

  index_name "persistent_articles"

end
