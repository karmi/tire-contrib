require 'rubygems'
require 'pathname'
require 'test/unit'
require 'shoulda'
require 'turn' unless ENV["TM_FILEPATH"] || ENV["CI"]
require 'mocha'
require 'active_support/core_ext/hash/indifferent_access'
require 'tire'

# => Require models for testing
require File.dirname(__FILE__) + '/dynamic_persistence/models/validated_model'
require File.dirname(__FILE__) + '/dynamic_persistence/models/persistent_article'
require File.dirname(__FILE__) + '/dynamic_persistence/models/persistent_article_in_index'
require File.dirname(__FILE__) + '/dynamic_persistence/models/persistent_article_in_namespace'
require File.dirname(__FILE__) + '/dynamic_persistence/models/persistent_article_with_casting'
require File.dirname(__FILE__) + '/dynamic_persistence/models/persistent_article_with_defaults'
require File.dirname(__FILE__) + '/dynamic_persistence/models/persistent_articles_with_custom_index_name'
require File.dirname(__FILE__) + '/dynamic_persistence/models/persistent_articles_with_dynamic_attributes'


class Test::Unit::TestCase

  def mock_response(body, code=200, headers={})
    Tire::HTTP::Response.new(body, code, headers)
  end

  def fixtures_path
    Pathname( File.expand_path( 'fixtures', File.dirname(__FILE__) ) )
  end

  def fixture_file(path)
    File.read File.expand_path( path, fixtures_path )
  end

end
