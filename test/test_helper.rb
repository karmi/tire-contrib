require 'rubygems'

require 'pathname'
require 'test/unit'

require 'shoulda'
require 'turn' unless ENV["TM_FILEPATH"] || ENV["CI"]
require 'mocha'

require 'tire'

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
