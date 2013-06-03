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

      context "Active model serializer include in tire models" do

        should "active model serializer is nil if no serializer exists" do
          assert_equal nil, Tire::Results::Item.new({"_type" => "RandomClass"}).active_model_serializer
        end

        should "active model serializer returned for item if serializer exists" do
          class ::Rails; end
          assert_equal SomeClassSerializer, Tire::Results::Item.new({"_type" => "SomeClass"}).active_model_serializer
          Object.class_eval{remove_const :Rails}
        end

        should "active model serializer with tire prefix returned for item if serializer exists" do
          class ::Rails; end
          assert_equal TireOtherClassSerializer, Tire::Results::Item.new({"_type" => "OtherClass"}).active_model_serializer
          Object.class_eval{remove_const :Rails}
        end

        should "active model serializer is ArraySerializer for Collection" do
          assert_equal ActiveModel::ArraySerializer, Tire::Results::Collection.new({}).active_model_serializer
        end

      end

    end
  end
end