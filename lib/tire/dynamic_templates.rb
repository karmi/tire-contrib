# Dynamic Templates support in mapping DSL
# ========================================
#
# This extension allows you to define the dynamic_templates property on the
# root object type in elasticsearch. This allows you to e.g easily do
# multi-fields on dynamic attributes. See the following URL for more info:
#
# http://www.elasticsearch.org/guide/reference/mapping/root-object-type/
#
# Usage:
# ------
#
#     require 'tire/dynamic_templates'
#     class MyModel # ...
#       include Tire::Model::Search
#       # ...
#       mapping do
#         dynamic_template "template_name",
#           match: '*',
#           match_mapping_type: 'string',
#           mapping: {
#             type: "multi_field",
#             fields: {
#               "{name}" => {
#                 type: "{dynamic_type}",
#                 index: "analyzed"
#               },
#               "org" => {
#                 type: "{dynamic_type}",
#                 index: "not_analyzed"
#               }
#             }
#           }
#       end
#     end
#

module Tire
  module Model
    Search::ClassMethodsProxy::INTERFACE.concat [:dynamic_template, :dynamic_templates]
    module Indexing
      module ClassMethods
        # Define a named dynamic template
        # (see http://www.elasticsearch.org/guide/reference/mapping/root-object-type/)
        def dynamic_template(name, options = {})
          dynamic_templates << {name => options}
          self
        end
        # Access existing dynamic templates
        def dynamic_templates
          @mapping_options ||= {}
          @mapping_options[:dynamic_templates] ||= []
        end
      end
    end
  end
end
