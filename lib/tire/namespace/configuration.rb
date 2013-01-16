module Tire
  module Namespace
    module Configuration
      def namespace(name = nil)
        @namespace = name || @namespace
      end
    end
  end
end
