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

        should 'allow new attributes to be defined' do
          @article = PersistentArticleWithDynamicCreation.new :name => 'Elasticsearch',
                                                              :title => 'You know, for Search!'
          @article.set_attribute(:reason, 'Just because!')

          assert_nothing_raised do
            assert_equal 'Just because!', @article.reason
          end
        end

        should 'allow existing attributes to be re-defined' do
          @article = PersistentArticleWithDynamicCreation.new :name => 'Elasticsearch',
                                                              :title => 'You know, for Search!',
                                                              :reason => 'Just because!'
          @article.set_attribute(:reason, 'New value!')

          assert_nothing_raised do
            assert_equal 'New value!', @article.reason
          end
        end

        should 'allow attributes to be set in a batch' do
          @article = PersistentArticleWithDynamicCreation.new :name => 'Elasticsearch',
                                                              :title => 'You know, for Search!'
          @article.set_attributes({:title => 'New title', :rating => 5})
          assert_nothing_raised do
            assert_equal 'New title', @article.title
            assert_equal 5, @article.rating
          end
        end

      end

    end
  end
end
