# Example class with Elasticsearch persistence and custom index name
require 'tire/model/dynamic_persistence'

class PersistentArticleWithCustomIndexName

  include Tire::Model::Persistence
  include Tire::Model::DynamicPersistence

  property :title

  index_name 'custom-index-name'
end
