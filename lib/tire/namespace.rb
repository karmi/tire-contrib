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
end
