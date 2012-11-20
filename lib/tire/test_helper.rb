module Tire

  module Model::Search

    class << self

      def included_with_storing(klass)
        Tire.add_model(klass)
        included_without_storing(klass)
      end

      alias_method_chain :included, :storing

    end

    class InstanceMethodsProxy

      def update_index_with_stub
        if Tire.allow_update
          update_index_without_stub
        end
      end
      alias_method_chain :update_index, :stub

    end

  end

  class Search::Search

    def perform_with_refresh(*args, &block)
      Tire.models.each { |m| m.tire.index.refresh }
      perform_without_refresh(*args, &block)
    end
    alias_method_chain :perform, :refresh

  end

  class << self

    def test_mode!(&block)
      cleanup
      @allow_update = true
      block.call
      @allow_update = false
      cleanup
    end

    def allow_update
      @allow_update
    end

    def add_model(model)
      @models = (models << model)
    end

    def models
      @models ||= []
    end

    def cleanup
      models.each do |m|
        m.tire.index.delete
        m.tire.create_elasticsearch_index
      end
    end

  end

end

Tire::Model::Search.index_prefix 'tire_test'
