require 'test_helper'

require 'tire/dynamic_templates'

include Mocha::API
class MockModel
  include Tire::Model::Search
  def self.model_name
    object = mock
    object.stubs(:to_s).returns('dynamic_field_mapped_model')
    object.stubs(:plural).returns('dynamic_field_mapped_models')
    object
  end
  MAPPING = {
    match: "*",
    match_mapping_type: 'string',
    mapping: {
      type: "multi_field",
      fields: {
        "{name}" => {
          type: "{dynamic_type}",
          index: "analyzed"
        },
        "org" => {
          type: "{dynamic_type}",
          index: "not_analyzed"
        }
      }
    }
  }
  mapping do
    dynamic_template "foo", MockModel::MAPPING
    dynamic_template "bar", MockModel::MAPPING
  end
end

module Tire
  module DynamicTemplates
    class MappingTest < Test::Unit::TestCase
      context "Dynamic templates defined" do
        should "correctly set dynamic_templates" do
          assert_equal MockModel.tire.mapping_to_hash, :dynamic_field_mapped_model => {
            :dynamic_templates => [
              {"foo" => MockModel::MAPPING},
              {"bar" => MockModel::MAPPING}
            ],
            :properties        => {}
          }
        end
      end
    end
  end
end
