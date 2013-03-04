# Example class with Elasticsearch persistence
require 'tire/model/dynamic_persistence'

class DynamicAuthor

  include Tire::Model::Persistence
  include Tire::Model::DynamicPersistence
end

class PersistentArticleWithDynamicCreation
  
  include Tire::Model::Persistence
  include Tire::Model::DynamicPersistence
  
  property :author, :class => DynamicAuthor
  property :tags,   :default => []
end
