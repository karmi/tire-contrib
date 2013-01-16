require 'tire'
require 'tire/namespace'
require 'shoulda'

module Tire
  module Namespace
    class IndexTest < Test::Unit::TestCase
      context "Namespace" do
        context "index" do
          def teardown
            Tire::Configuration.reset
          end

          should "return the name with an namespace" do
            Tire.configure { namespace "foo" }
            assert_equal "foo-bar", Tire.index("bar").name
          end

          should "return the name with an namespace (with block)" do
            Tire.configure { namespace "foo" }
            index = Tire.index("xxx") do
              @name = "bar"
            end
            assert_equal "foo-bar", index.name
          end

          should "return the name without an namespace" do
            assert_equal "bar", Tire.index("bar").name
          end
        end
      end
    end
  end
end
