require 'test_helper'
require 'tire'
require 'tire/queries/custom_filters_score'

module Tire
  module Search
    class CustomFiltersScoreTest < Test::Unit::TestCase
      context "CustomFiltersScoreQuery" do

        should "not raise an error when no block is given" do
          assert_nothing_raised { Query.new.custom_filters_score }
        end

        should "provides a default filter if no filter is given" do
          query = Query.new.custom_filters_score do
            query { term :foo, 'bar' }
          end

          query[:custom_filters_score].tap do |f|
            assert_equal( { :term => { :foo => { :term => 'bar' } } }, f[:query].to_hash )
            assert_equal( { :match_all => {} }, f[:filters].first[:filter])
            assert_equal( 1.0, f[:filters].first[:boost])
          end
        end

        should "properly encode filter with boost" do
          query = Query.new.custom_filters_score do
            query { term :foo, 'bar' }
            filter do
              filter :terms, :tags => ['ruby']
              boost 2.0
            end
          end

          query[:custom_filters_score].tap do |f|
            assert_equal( { :term => { :foo => { :term => 'bar' } } }, f[:query].to_hash )
            assert_equal( { :tags => ['ruby'] }, f[:filters].first[:filter][:terms])
            assert_equal( 2.0, f[:filters].first[:boost])
          end
        end

        should "properly encode filter with script" do
          query = Query.new.custom_filters_score do
            query { term :foo, 'bar' }
            filter do
              filter :terms, :tags => ['ruby']
              script '_score * 2.0'
            end
          end

          query[:custom_filters_score].tap do |f|
            assert_equal( { :term => { :foo => { :term => 'bar' } } }, f[:query].to_hash )
            assert_equal( { :tags => ['ruby'] }, f[:filters].first[:filter][:terms])
            assert_equal( '_score * 2.0', f[:filters].first[:script])
          end
        end

        should "properly encode multiple filters" do
          query = Query.new.custom_filters_score do
            query { term :foo, 'bar' }
            filter do
              filter :terms, :tags => ['ruby']
              boost 2.0
            end
            filter do
              filter :terms, :tags => ['python']
              script '_score * 2.0'
            end
          end

          query[:custom_filters_score].tap do |f|
            assert_equal( { :term => { :foo => { :term => 'bar' } } }, f[:query].to_hash )
            assert_equal( { :tags => ['ruby'] }, f[:filters].first[:filter][:terms])
            assert_equal( 2.0, f[:filters].first[:boost])
            assert_equal( { :tags => ['python'] }, f[:filters].last[:filter][:terms])
            assert_equal( '_score * 2.0', f[:filters].last[:script])
          end
        end

        should "allow setting the score_mode" do
          query = Query.new.custom_filters_score do
            query { term :foo, 'bar' }
            score_mode 'total'
          end

          query[:custom_filters_score].tap do |f|
            assert_equal( { :term => { :foo => { :term => 'bar' } } }, f[:query].to_hash )
            assert_equal( 'total', f[:score_mode])
          end
        end

      end
    end
    
  end
end
