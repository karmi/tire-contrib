# Example class with Elasticsearch persistence
require 'tire/model/dynamic_persistence'

class PersistentArticle

  include Tire::Model::Persistence
  include Tire::Model::DynamicPersistence

  property :title
  property :published_on
  property :tags

end
