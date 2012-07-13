# Based on test suite from @evanphx:
#
# <https://github.com/evanphx/newrelic-redis>
#

require 'test_helper'

require 'tire/new_relic/instrumentation'
require 'tire/new_relic/model'
require File.expand_path('../model', __FILE__)

module Tire
  module NewRelic

    class InstrumentationTest < Test::Unit::TestCase

      include ::NewRelic::Agent::Instrumentation::ControllerInstrumentation

      def setup
        ::NewRelic::Agent.manual_start

        @engine = ::NewRelic::Agent.instance.stats_engine
        @engine.clear_stats

        DependencyDetection.detect!
      end

      def assert_metrics(*m)
        m.each { |x| assert_contains @engine.metrics, x }
      end

      context "NewRelic instrumentation for" do

        context "Tire::Index" do

          should "trace the class" do
            assert Tire.index('foo').traced?
          end

          should "trace the method calls" do
            Tire.index('foo').exists?
            assert_metrics "Search/Tire/index_exists?"
          end

          should "trace delete/create" do
            Tire.index('foo').delete
            Tire.index('foo').create
            assert_metrics "Search/Tire/index_delete", "Search/Tire/index_create"
          end

          should "trace percolate" do
            Tire.index('foo').percolate foo: 'bar'
            assert_metrics "Search/Tire/index_percolate"
          end

        end

        context "Tire::DSL" do

          should "trace the method calls" do
            Tire.search 'foo'
            assert_metrics "Search/Tire/search"
          end

        end

        # context "Tire::Search::Search" do
        #
        #   should "trace perform" do
        #     Tire.search('foo').results
        #
        #     assert_metrics "Search/Tire/perform"
        #   end
        #
        # end

        context "ActiveModel integration" do

          should "be traced" do
            assert TestModel.traced?
          end

          should "trace search" do
            TestModel.search('foo').results
            # p @engine.metrics
            assert_metrics "Search/TestModel/search"
          end

          should_eventually "trace search via proxy object" do
            TestModel.tire.search('foo').results
            assert_metrics "Search/TestModel/search"
          end

          should "trace index updates" do
            TestModel.new(title: 'foo').update_index
            assert_metrics "Search/TestModel/update_index"
          end

          should_eventually "trace index updates via callbacks" do
            TestModel.new(title: 'foo').save
            assert_metrics "Search/TestModel/update_index"
          end

        end

      end

    end

  end

end
