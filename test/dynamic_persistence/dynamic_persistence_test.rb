require 'test_helper'

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

module Tire
  module Model

    class DynamicPersistenceTest < Test::Unit::TestCase

      context "Persistent model with dynamic creation" do

        should "allow accessing attributes not explicitely defined" do
          @article = PersistentArticleWithDynamicCreation.new :name => 'Elasticsearch',
                                                              :title => 'You know, for Search!'
          assert_nothing_raised do
            assert_equal 'Elasticsearch', @article.name
          end
        end

        should "not override explicitely defined properties" do
          @article = PersistentArticleWithDynamicCreation.new :name => 'Elasticsearch',
                                                              :author => { :name => 'Inigo Montoya' }

          assert_instance_of DynamicAuthor, @article.author
          assert_equal      'Inigo Montoya', @article.author.name

          assert_instance_of Array, @article.tags
          assert_equal [], @article.tags
        end

      end

    end
  end
end
