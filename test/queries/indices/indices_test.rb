require 'tire'
require 'tire/queries/indices'
require 'shoulda'

module Tire
  module Search
    class IndicesTest < Test::Unit::TestCase
      context "IndicesQuery" do

        should "search across multiple indices" do
          hash = {
            :indices => {
              :indices => ["index1", "index2"],
              :query => {
                :query_string => {
                  :query => "wow"
                }
              },
              :no_match_query => {
                :query_string => {
                  :query => "kow"
                }
              }
            }
          }
          query = Query.new.indices ['index1', 'index2'] do
            query do
              string 'wow'
            end
            no_match_query do
              string 'kow'
            end
          end
          assert_equal(hash, query)
        end

        should "accept strings as no_match_query parameter" do
          hash = {
            :indices => {
              :indices => ["index1", "index2"],
              :query => {
                :query_string => {
                  :query => "wow"
                }
              },
              :no_match_query => "none"
            }
          }
          query = Query.new.indices ['index1', 'index2'] do
            query do
              string 'wow'
            end
            no_match_query "none"
          end
          assert_equal(hash, query)
        end
      end
    end
  end
end
