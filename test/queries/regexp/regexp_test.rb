require 'tire'
require 'tire/queries/regexp'
require 'shoulda'

module Tire
  module Search
    class RegexpTest < Test::Unit::TestCase
      
      context "Regexp queries" do
        should "search for documents that have fields matching a regular expression" do
          assert_equal({:regexp => {'name.first' => { :value => 's.*y'}}}, Query.new.regexp('name.first', 's.*y'))
        end

        should "allow to boost a regexp query" do
          assert_equal({:regexp => {'name.first' => { :value => 's.*y', :boost => 2.0}}},
                       Query.new.regexp("name.first", 's.*y', :boost => 2.0))
        end
        
        should "allow to use special flags" do
          assert_equal({:regexp => {'name.first' => { :value => 's.*y', :flags => 'INTERSECTION|COMPLEMENT|EMPTY'}}},
                      Query.new.regexp('name.first', 's.*y', :flags => [:intersection, :complement, :empty]))
        end
      end
      
      context "validate the options passed" do
        should "drop all the invalid keys" do
          assert_equal({:regexp => {'name.first' => {:value => 's.*y', :boost => 2.0}}},
                       Query.new.regexp('name.first', 's.*y', :boost => 2.0, :foo => :bar))
          assert_equal({:regexp => {'name.first' => {:value => 's.*y', :boost => 2.0}}},
                       Query.new.regexp('name.first', 's.*y', :boost => 2.0, :fields => [:bar]))
        end
        
        should "drop all the invalid flags" do
          assert_equal({:regexp => {'name.first' => {:value => 's.*y', :flags => 'INTERSECTION|COMPLEMENT|EMPTY'}}},
                      Query.new.regexp('name.first', 's.*y', :flags => [:intersection, :bar, :baz, :complement, :empty]))
        end
      end
    end
  end
end