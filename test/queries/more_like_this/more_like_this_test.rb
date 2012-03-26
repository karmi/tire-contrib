require 'tire'
require 'tire/queries/more_like_this'
require 'shoulda'

module Tire
  module Search
    class MoreLikeThisTest < Test::Unit::TestCase
      context "More Like This queries" do
        should "search for similar documents" do
          assert_equal({:mlt => {:like_text => 'similar text'}}, Query.new.mlt('similar text'))
        end

        should "allow to pass a list of fields to a mlt query" do
          assert_equal({:mlt => {:like_text => 'similar text', :fields => ['foo', 'bar.baz']}},
                       Query.new.mlt('similar text', :fields => ['foo', 'bar.baz']))
          assert_equal({:mlt => {:like_text => 'similar text', :fields => ['foo', 'bar.baz'], :min_term_freq => 3}},
                       Query.new.mlt('similar text', :fields => ['foo', 'bar.baz'], :min_term_freq => 3))
        end

        should "search for similar text on a selected field (mlt_field)" do
          assert_equal({:mlt_field => {:foo => {:like_text => 'similar text'}}},
                       Query.new.mlt_field(:foo, 'similar text'))
          assert_equal({:mlt_field => {:foo => {:like_text => 'similar text', :min_term_freq => 1}}},
                       Query.new.mlt_field(:foo, 'similar text', :min_term_freq => 1))
        end
      end
      context "validate the options passed" do
        should "drop all the invalid keys" do
          assert_equal({:mlt => {:like_text => 'similar text', :fields => ['foo', 'bar.baz']}},
                       Query.new.mlt('similar text', :fields => ['foo', 'bar.baz'], :foo => :bar))
          assert_equal({:mlt_field => {:foo => {:like_text => 'similar text'}}},
                       Query.new.mlt_field(:foo, 'similar text', :fields => [:bar]))
        end
      end
    end
  end
end
