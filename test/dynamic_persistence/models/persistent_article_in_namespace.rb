# Example namespaced class with Elasticsearch persistence
#
# The `document_type` is `my_namespace/persistent_article_in_namespace`
#
require 'tire/model/dynamic_persistence'

module MyNamespace
  class PersistentArticleInNamespace
    
    include Tire::Model::Persistence
    include Tire::Model::DynamicPersistence

    property :title
  end
end
