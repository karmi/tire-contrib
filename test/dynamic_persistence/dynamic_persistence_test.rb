require 'test_helper'

module Tire
  module Model

    class DynamicPersistenceTest < Test::Unit::TestCase

      context "Persistent model with dynamic creation" do
                
        should "permit access to attrs passed to create" do 
          @article = PersistentArticleWithDynamicCreation.new :name => 'Elasticsearch', :title => 'You know, for Search!'
          assert_equal @article.name, 'Elasticsearch'
        end
        
        should "not override explicit persistent properties" do
          @article = PersistentArticleWithDynamicCreation.new :name => 'Elasticsearch', :author => { :name => 'Inigo Montoya' }
          assert_equal @article.author.name, 'Inigo Montoya'
          assert_equal @article.tags.class, Array
          assert_equal @article.tags.length, 0
        end
        
      end

    end
  end
end
