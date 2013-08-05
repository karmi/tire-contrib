require 'common_pool'
require 'curb'

# A Curb-based client which uses the "common-pool" gem to allow high-performance
# HTTP requests in a multi-threaded environment.
#
# See <https://github.com/jugend/common-pool>
#
# Make sure to include the "common-pool" gem in your Gemfile.
#
# Example:
# --------
#
#     require 'curb'
#     require 'tire/http/clients/pooled_curb'
#
#     Tire::HTTP::Client::PooledCurbConfiguration.instance.retries = 1
#     Tire::HTTP::Client::PooledCurbConfiguration.instance.timeout = 2
#
#     Tire.configure do
#       client Tire::HTTP::Client::PooledCurb
#     end
#
module Tire
  module HTTP
    module Client

      class PooledCurbDataSource < CommonPool::PoolDataSource
        def create_object
          Curl::Easy.new
        end
      end

      class PooledCurbConfiguration
        include Singleton

        attr_writer :retries, :timeout

        def retries
          @retries || 3
        end

        def timeout
          @timeout || 15
        end
      end

      class PooledCurb
        HTTP_CLIENT_POOL = CommonPool::ObjectPool.new(PooledCurbDataSource.new) do |config|
          config.max_active = 200
        end

        def self.with_client
          curl = HTTP_CLIENT_POOL.borrow_object
          begin
            yield curl
          rescue Curl::Err::MultiBadEasyHandle
            curl = HTTP_CLIENT_POOL.borrow_object
            retry
          ensure
            HTTP_CLIENT_POOL.return_object(curl)
          end
        end

        def self.get(url, data=nil)
          response = nil

          PooledCurbConfiguration.instance.retries.times do |tries|
            begin
              response = get_once(url, data)
              if block_given?
                next unless yield response.body, response.code
              else
                next unless response.code == 200 && response.present?
              end

              return response
            rescue Curl::Err::CurlError
              # Retry the request.
            end
          end

          response
        end

        def self.get_once(url, data=nil)
          with_client do |curl|
            curl.timeout = PooledCurbConfiguration.instance.timeout
            curl.url = url
            if data
              curl.post_body = data
              curl.http_post
            else
              curl.http_get
            end
            Response.new curl.body_str, curl.response_code
          end
        end

        def self.post(url, data)
          with_client do |curl|
            curl.timeout = PooledCurbConfiguration.instance.timeout
            curl.url = url
            curl.post_body = data
            curl.http_post
            Response.new curl.body_str, curl.response_code
          end
        end

        def self.put(url, data)
          with_client do |curl|
            curl.timeout = PooledCurbConfiguration.instance.timeout
            curl.url = url
            curl.http_put data
            Response.new curl.body_str, curl.response_code
          end
        end

        def self.delete(url)
          with_client do |curl|
            curl.timeout = PooledCurbConfiguration.instance.timeout
            curl.url = url
            curl.http_delete
            Response.new curl.body_str, curl.response_code
          end
        end

        def self.head(url)
          with_client do |curl|
            curl.timeout = PooledCurbConfiguration.instance.timeout
            curl.url = url
            curl.http_head
            Response.new curl.body_str, curl.response_code
          end
        end
      end

    end
  end
end
