require 'tire/namespace/index'
require 'tire/namespace/configuration'

module Tire
  Index.class_eval do
    include Tire::Namespace::Index
  end

  Configuration.class_eval do
    extend Tire::Namespace::Configuration
  end
end
