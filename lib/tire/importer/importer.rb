# encoding: UTF-8

require 'benchmark'

STDOUT.sync = true

module Tire
  module Importer

    class Importer

      def initialize(options={})
        @input      = options[:input]
        @index      = options[:index]
        @batch_size = options[:batch_size] || 1_000
        @total      = 0
        @disable_refresh = true

        raise ArgumentError, "options[:input] missing" unless @input
        raise ArgumentError, "options[:index] missing" if @index.empty?

        Tire.configure do
          client Tire::HTTP::Client::Curb
        end
      end

      def perform!
        index = Tire.index(@index)
        if @disable_refresh
          @refresh_interval = index.settings['index.refresh_interval']
          Tire::Configuration.client.put [index.url, '_settings'].join('/'),
                                         '{"index":{"refresh_interval" : "-1"}}'
        end
        elapsed = Benchmark.realtime do
          read_and_process
        end
        STDERR.puts "All done in #{elapsed} seconds (#{(@total/elapsed).round} docs/sec)"
      ensure
        if @disable_refresh
          refresh_interval = @refresh_interval || '1s'
          Tire::Configuration.client.put [index.url, '_settings'].join('/'),
                                         %Q|{"index":{"refresh_interval" : "#{refresh_interval}"}}|
        end
      end

      def read_and_process
        @batch_nr, @buffer = 1, []

        @input.each &method(:process)
        Process.waitall

        store_batch @buffer unless @buffer.empty?

        STDERR.puts '='*80, "Stored #{@batch_nr} batches into '#{@index}' index."
      end

      def process(line)
        @buffer << MultiJson.load(line.chomp)

        if @buffer.size > (@batch_size - 1)
          store_batch @buffer
          @total += @buffer.size
          @buffer = []
          @batch_nr += 1
        end
      end

      def store_batch(collection)
        STDERR.puts '='*80, "Storing batch ##{@batch_nr}"
        elapsed = Benchmark.realtime do
          STDOUT.puts Tire.index(@index).bulk_create(collection).body
        end
        STDERR.puts "Batch ##{@batch_nr} stored in #{elapsed} seconds"
      end

    end

  end
end
