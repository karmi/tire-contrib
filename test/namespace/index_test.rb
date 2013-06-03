require 'test_helper'

require 'tire/namespace'

module Tire
  module Namespace
    class IndexTest < Test::Unit::TestCase
      context "Namespaced index" do
        teardown { Tire::Configuration.reset }

        should "return the name with the namespace" do
          Tire.configure { namespace "foo" }
          assert_equal "foo-bar", Tire.index("bar").name
        end

        should "return the name without the namespace" do
          assert_equal "bar", Tire.index("bar").name
        end

        should "work with the namespaced name across the API" do
          Tire.configure { namespace "foo" }
          index = Tire.index('bar')

          Tire::Configuration.client.expects(:head).with do |url|
            assert_equal 'http://localhost:9200/foo-bar', url
            true
          end.returns(mock_response('OK'))

          index.exists?
        end
      end
    end
  end
end
