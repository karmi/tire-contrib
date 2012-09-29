# NewRelic Instrumentation
# ========================
#
# Author: Karel Minarik <karmi@karmi.cz>
#
# Adds instrumentation support for the [NewRelic](http://newrelic.com) application performance management tool.
#
# Usage:
# ------
#
# For tracing Tire::Index and Tire::DSL method calls, just require the component
# (eg. in a Ruby On Rails initializer):
#
#     require 'tire/new_relic/instrumentation'
#
# For tracing search calls in the ActiveModel model integration, in addition
# to requiring the component, include the tracing module in your model:
#
#     class MyModel
#       include Tire::Model::Search
#       include Tire::Model::NewRelic unless Rails.env.test?
#     end
#
# You'll find the statistics in the "Diagnostics > Transaction Traces" page at NewRelic.
# See an example image here: <https://img.skitch.com/20120713-t5knmkxnu8r9n6iu156phitdfp.png>
#
# Often, you perform multiple search requests in your application, eg. within a Rails controller action.
# Currently, all these search requests are bundled into one metric.
# To measure individual search requests, you have to use the custom NewRelic instrumentation:
#
#     class ArticlesController < ApplicationController
#       extend NewRelic::Agent::MethodTracer
#       # ...
#       def index
#         self.class.trace_execution_scoped(['ArticlesController/Index/main_search']) do
#           @articles = Article.search do |search|
#             # ...
#           end
#         end
#
#         self.class.trace_execution_scoped(['ArticlesController/Index/category_facets']) do
#           # ...
#         end
#         # ...
#
#         respond_with(@articles)
#       end
#     end
#
# See <https://newrelic.com/docs/ruby/ruby-custom-metric-collection#example_blocks> for more information.
#
# TODO
# ----
#
# * Implement tracing for searches via the proxy object (`MyModel.tire.search ...`)
# * Implement tracing for `update_index` via `after_save` callbacks (again, proxied)
# * Implement tracing for different search queries, if possible
#
# More Information:
# -----------------
#
#     * https://newrelic.com/docs/ruby/ruby-custom-metric-collection
#     * https://github.com/newrelic/rpm/tree/master/lib/new_relic/agent/instrumentation
#     * https://github.com/newrelic/rpm_contrib/tree/master/lib/rpm_contrib/instrumentation
#
require 'new_relic/agent/method_tracer'
require 'tire/new_relic/model'

module Tire
  module NewRelic

    module Helpers
      extend ::NewRelic::Agent::MethodTracer

      # Helper method to add multiple methods in a certain scope
      #
      def add_method_tracers methods, metric_name_code
        methods.each do |method_name|
          add_method_tracer method_name.to_sym, "#{metric_name_code}#{method_name}"
        end
      end
    end

  end
end

DependencyDetection.defer do
  @name = :tire

  depends_on do
    defined?(::Tire) and not NewRelic::Control.instance['disable_tire_instrumentation']
  end

  executes do
    NewRelic::Agent.logger.debug 'Installing Tire instrumentation...'
  end

  executes do

    ::Tire::Index.class_eval do
      include ::NewRelic::Agent::MethodTracer
      extend  ::Tire::NewRelic::Helpers

      add_method_tracers %w|
          exists?
          delete
          create
          add_alias
          remove_alias
          aliases
          mapping
          settings
          store
          bulk_store
          import
          reindex
          remove
          retrieve
          update
          refresh
          open
          close
          analyze
          register_percolator_query
          unregister_percolator_query
          percolate
        |,
        'Search/Tire/index_'
    end

    ::Tire::DSL.class_eval do
      include ::NewRelic::Agent::MethodTracer
      extend  ::Tire::NewRelic::Helpers

      add_method_tracers %w| search index scan aliases |, 'Search/Tire/'
    end

    # ::Tire::Search::Search.class_eval do
    #   include ::NewRelic::Agent::MethodTracer
    #   extend  ::Tire::NewRelic::Helpers
    #
    #   add_method_tracers %w| perform |, 'Search/Tire/'
    # end

  end
end
