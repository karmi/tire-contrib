require 'tire'
require 'tire/queries/wildcard'
require 'shoulda'

module Tire
  module Search
    class WildcardTest < Test::Unit::TestCase
      
      context "Wildcard queries" do
        should "search for documents that have fields matching a wildcard expression" do
          assert_equal({:wildcard => {:user => {:value => 'ki*y'}}}, Query.new.wildcard(:user, 'ki*y'))
        end

        should "allow to boost a wildcard query" do
          assert_equal({:wildcard => {:user => {:value => 'ki*y', :boost => 2.0}}},
                       Query.new.wildcard(:user, 'ki*y', :boost => 2.0))
        end
      end
      
      context "validate the options passed" do
        should "drop all the invalid keys" do
          assert_equal({:wildcard => {:user => {:value => 'ki*y', :boost => 2.0}}},
                       Query.new.wildcard(:user, 'ki*y', :boost => 2.0, :foo => :bar))
          assert_equal({:wildcard => {:user => {:value => 'ki*y', :boost => 2.0}}},
                       Query.new.wildcard(:user, 'ki*y', :boost => 2.0, :fields => [:bar]))
        end
      end
    end
  end
end
