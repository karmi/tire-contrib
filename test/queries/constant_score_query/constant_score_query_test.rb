require 'test_helper'
require 'tire'
require 'tire/queries/constant_score_query'

module Tire
  module Search
    class ConstantScoreQueryTest < Test::Unit::TestCase
      context "ConstantScoreQuery" do

        should "not raise an error when no block is given" do
          assert_nothing_raised { Query.new.constant_score }
        end

        should "properly encode filter with boost" do
          query = Query.new.constant_score do
            query { term :foo, 'bar' }
            filter :terms, :tags => ['ruby']
            boost 3
          end

          query[:constant_score].tap do |f|
            assert_equal( { :term => { :foo => { :term => 'bar' } } }, f[:query].to_hash )
            assert_equal( { :tags => ['ruby'] }, f[:filter][:and].first[:terms] )
            assert_equal( 3.0, f[:boost])
          end
        end

        should "properly encode multiple filters" do
          query = Query.new.constant_score do
            query { term :foo, 'bar' }
            filter :terms, :tags => ['ruby']
            filter :terms, :tags => ['python']
          end

          query[:constant_score][:filter].tap do |filter|
            assert_equal 1, filter.size
            assert_equal( { :tags => ['ruby'] },   filter[:and].first[:terms] )
            assert_equal( { :tags => ['python'] }, filter[:and].last[:terms] )
          end
        end

        should "allow passing variables from outer scope" do
          @my_query  = 'bar'
          @my_filter = { :tags => ['ruby'] }

          query = Query.new.constant_score do |f|
            f.query { |q| q.term :foo, @my_query }
            f.filter :terms, @my_filter
          end

          query[:constant_score].tap do |f|
            assert_equal( { :term => { :foo => { :term => 'bar' } } }, f[:query].to_hash )
            assert_equal( { :tags => ['ruby'] }, f[:filter][:and].first[:terms] )
          end
        end

        should "keep score constant disregarding amount of filters" do
          query = Query.new.constant_score do
            filter :terms, :tags => ['ruby']
            filter :terms, :tags => ['python']
            boost 3
          end

          query[:constant_score].tap do |f|
            assert_equal( 3.0, f[:boost])
          end
        end

      end
    end

  end
end
