require 'tire'
require 'tire/queries/fuzzy_like_this'
require 'shoulda'

module Tire
  module Search
    class FuzzyLikeThisTest < Test::Unit::TestCase
      context "Fuzzy Like This queries" do
        should "search for similar documents" do
          assert_equal({:flt => {:like_text => 'similar text'}}, Query.new.flt('similar text'))
        end
      end

      should "allow to pass a list of fields to a flt query" do
        assert_equal({:flt => {:like_text => 'similar text', :fields => ['foo', 'bar.baz']}},
                     Query.new.flt('similar text', :fields => ['foo', 'bar.baz']))

        assert_equal({:flt => {:like_text => 'similar text', :fields => ['foo', 'bar.baz'], :min_similarity => 0.8}},
                     Query.new.flt('similar text', :fields => ['foo', 'bar.baz'], :min_similarity => 0.8))
      end

     should "search for similar text on a selected field (flt_field)" do
        assert_equal({:flt_field => {:foo => {:like_text => 'similar text'}}},
                     Query.new.flt_field(:foo, 'similar text'))

        assert_equal({:flt_field => {:foo => {:like_text => 'similar text', :min_similarity => 0.8}}},
                     Query.new.flt_field(:foo, 'similar text', :min_similarity => 0.8))
      end
      

      context "validate the options passed" do
        should "drop all the invalid keys" do
          assert_equal({:flt => {:like_text => 'similar text', :fields => ['foo', 'bar.baz']}},
                       Query.new.flt('similar text', :fields => ['foo', 'bar.baz'], :foo => :bar))

          assert_equal({:flt_field => {:foo => {:like_text => 'similar text'}}},
                       Query.new.flt_field(:foo, 'similar text', :fields => [:bar]))
        end
      end
    end
  end
end
