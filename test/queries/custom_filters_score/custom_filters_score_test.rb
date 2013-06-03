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

        should "allow setting params" do
          query = Query.new.custom_filters_score do
            query { term :foo, 'bar' }
            params :a => 'b'
          end

          f = query[:custom_filters_score]
          assert_equal( { :term => { :foo => { :term => 'bar' } } }, f[:query].to_hash )
          assert_equal( { :a => 'b' }, f[:params] )
        end
      end

      context 'CustomFiltersScore Integration' do
        context 'Query for "volmer", scored by "created_at"' do
          current_timestamp = Time.now.to_i * 1000
          score_script = "((0.08 / ((3.16*pow(10,-11)) * abs(now - doc['created_at'].date.getMillis()) + 0.05)))"

          query = Query.new.custom_filters_score do
            query { string 'volmer' }

            params :now => current_timestamp

            filter do
              filter :exists, :field => 'created_at'
              script score_script
            end
          end

          f = query[:custom_filters_score]

          should 'query for "volmer"' do
            assert_equal( { :query => 'volmer' }, f[:query][:query_string] )
          end

          should 'assing the "now" param with the current timestamp' do
            assert_equal( current_timestamp, f[:params][:now] )
          end

          context 'filters list' do
            should 'include an "exists" filter for the field "created_at"' do
              filter = f[:filters].first[:filter]
              assert_equal( { :field => 'created_at' }, filter[:exists] )
            end

            should 'include the score script in the filter' do
              assert_equal( score_script, f[:filters].first[:script] )
            end
          end
        end
      end
    end
  end
end
