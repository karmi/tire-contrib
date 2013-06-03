# Index Namespace
# ===============
#
# Author: Timo Schilling <timo@schilling.io>
#
# This extension allows you to "namespace" index operations in Tire.
#
# Usage:
# ------
#
#     require 'tire/namespace'
#
#     Tire.configure do
#       namespace("foo")
#     end
#
#     Tire.index("bar").name
#     => "foo-bar"
#
#     Tire.index("bar").exists?
#     => curl -I "http://localhost:9200/foo-bar"
#
require 'tire/namespace/index'
require 'tire/namespace/configuration'

module Tire
  Index.send :include, Tire::Namespace::Index
  Configuration.send :extend, Tire::Namespace::Configuration
  # Index.class_eval do
  #   include Tire::Namespace::Index
  #   extend Tire::Namespace::Index
  # end

  # Configuration.class_eval do
  #   extend Tire::Namespace::Configuration
  # end

  # class Index
  #   # def initialize(name, &block)
  #   #   require 'pry'
  #   #   binding.pry
  #   #   @name = Tire::Configuration.namespace ? "#{Tire::Configuration.namespace}-#{name}" : name
  #   #   block.arity < 1 ? instance_eval(&block) : block.call(self) if block_given?
  #   # end
  #   include Tire::Namespace::Index
  #   extend Tire::Namespace::Index
  # end
end
