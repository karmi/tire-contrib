# More Like This
# ==============
#
# Author: Mereghost <marcello.rocha@gmail.com>
#
#
# Adds support for "more_like_this" and "more_like_this_field" queries in Tire DSL.
#
# It hooks into the Query class and inserts the more_like_this and more_like_this_field query types.
#
#
# Usage:
# ------
#
# Require the component:
#
#     require 'tire/queries/more_like_this'
#
# From that point on you should have the more_like_this (aliased to mlt) and
# the more_like_this_field (aliased to mlt_field) queries available.
#
#
# Example:
# -------
#
#     Tire.search 'articles' do
#       query do
#          more_like_this 'search for similar text'
#          more_like_this_field :field_name, 'similar text'
#       end
#     end
#
# For available options for these queries see:
#
# * <http://www.elasticsearch.org/guide/reference/query-dsl/mlt-query.html>
# * <http://www.elasticsearch.org/guide/reference/query-dsl/mlt-field-query.html>
#
#
require 'tire/queries/more_like_this/more_like_this'

Tire::Search::Query.class_eval do
  include Tire::Search::MoreLikeThis::Query
end

module Tire::Model::Search::InstanceMethods
  # Returns search results for a given query.
  #
  # Query can be passed simply as a String:
  #
  #     @article.more_like_this 'love'
  #
  # Any options, such as pagination or sorting, can be passed as a second argument:
  #
  #     @article.more_like_this 'love', :per_page => 25, :page => 2
  #     @article.more_like_this 'love', :sort => 'title'
  #
  # For more powerful query definition, use the query DSL passed as a block:
  #
  #     @article.more_like_this do
  #       query { terms :tags, ['ruby', 'python'] }
  #       facet 'tags' { terms :tags }
  #     end
  #
  # You can pass options as the first argument, in this case:
  #
  #     @article.more_like_this :per_page => 25, :page => 2 do
  #       query { string 'love' }
  #     end
  #
  # This methods returns a Tire::Results::Collection instance, containing instances
  # of Tire::Results::Item, populated by the data available in _Elasticsearch, by default.
  #
  # If you'd like to load the "real" models from the database, you may use the `:load` option:
  #
  #     @article.more_like_this 'love', :load => true
  #
  # You can pass options as a Hash to the model's `find` method:
  #
  #     @article.more_like_this :load => { :include => 'comments' } do ... end
  #
  def more_like_this(*args, &block)
    default_options = {:type => instance.class.tire.document_type, :index => instance.class.tire.index.name}

    if block_given?
      options = args.shift || {}
    else
      query, options = args
      options ||= {}
    end

    options[:mlt_fields] = options[:mlt_fields].join(',') if options[:mlt_fields]
    options   = default_options.update(options)
    sort      = Array( options.delete(:order) || options.delete(:sort) )

    s = Tire::Search::MoreLikeThis::Search.new(options.delete(:index), instance.id, options)

    page     = options.delete(:page)
    per_page = options.delete(:per_page) || Tire::Results::Pagination::default_per_page

    s.size( per_page.to_i ) if per_page
    s.from( page.to_i <= 1 ? 0 : (per_page.to_i * (page.to_i-1)) ) if page && per_page

    s.sort do
      sort.each do |t|
        field_name, direction = t.split(':')
        by field_name, direction
      end
    end unless sort.empty?

    version = options.delete(:version)
    s.version(version) if version

    if block_given?
      block.arity < 1 ? s.instance_eval(&block) : block.call(s)
    else
      s.query { string query }
      # TODO: Actualy, allow passing all the valid options from
      # <http://www.elasticsearch.org/guide/reference/api/search/uri-request.html>
      s.fields Array(options[:fields]) if options[:fields]
    end

    s.results
  end
end
