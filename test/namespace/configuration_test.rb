require 'tire'
require 'tire/namespace'
require 'shoulda'

module Tire
  module Namespace
    class ConfigurationTest < Test::Unit::TestCase
      context "Namespace" do
        context "Configuration" do
          def teardown
            Tire::Configuration.reset
          end

          should "extend Tire::Configuration with 'namespace'" do
            assert_nothing_raised { Tire::Configuration.namespace("foo") }
          end

          should "set namespace" do
            Tire::Configuration.namespace("foo")
            assert_equal "foo", Tire::Configuration.instance_variable_get(:@namespace)
          end

          should "get namespace" do
            Tire::Configuration.instance_variable_set(:@namespace, "bar")
            assert_equal "bar", Tire::Configuration.namespace
          end
        end
      end
    end
  end
end
