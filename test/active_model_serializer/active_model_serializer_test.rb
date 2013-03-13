require 'test_helper'

require 'tire/model/active_model_serializer'

class SomeClass
  include ActiveModel::SerializerSupport
end

class SomeClassSerializer
end

class OtherClass
  include ActiveModel::SerializerSupport
end

class TireOtherClassSerializer
end

class OtherClassSerializer
end

module Tire
  module Model

    class ActiveModelSerializerTest < Test::Unit::TestCase

      context "Active model serializer integration in Tire models" do

        should "return nil if no serializer exists" do
          assert_equal nil, Tire::Results::Item.new({"_type" => "RandomClass"}).active_model_serializer
        end

        should "return a serializer" do
          class ::Rails; end
          assert_equal SomeClassSerializer, Tire::Results::Item.new({"_type" => "SomeClass"}).active_model_serializer
          Object.class_eval{remove_const :Rails}
        end

        should "return a Tire prefixed serializer" do
          class ::Rails; end
          assert_equal TireOtherClassSerializer, Tire::Results::Item.new({"_type" => "OtherClass"}).active_model_serializer
          Object.class_eval{remove_const :Rails}
        end

        should "be an ArraySerializer for Tire::Results::Collection" do
          assert_equal ActiveModel::ArraySerializer, Tire::Results::Collection.new({}).active_model_serializer
        end

      end

    end
  end
end
