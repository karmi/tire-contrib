# Active Model Serializer
# ===================
#
# Author: Sergey Efremov <efremov.sergey@gmail.com>
#
#
# Adds support for serialization through ActiveModel::Serializers to Tire::Model::Collection
# and Tire::Results::Item. ActiveModel::Serializers provide simple way to encapsulate serialization of ActiveModel objects.
# More info about userga of ActiveModel::Serializers here: https://github.com/rails-api/active_model_serializers
# For Vacancy model from Tire::Result will use TireVacancySerializer, if not exist will fallback to VacancySerializer.
#
#
# Usage:
# ------
#
# Require the component:
#
#     require 'tire/model/active_model_serializer'
#
# Example:
# -------
#
#     class VacancySerializer < ActiveModel::Serializer
#       attributes :position, :body, :location
#       
#       def location
#         "#{city}, #{state}, #{country}"
#       end
#     
#     end
#
#     class VacanciesController < ApplicationController
#       
#       def index
#         render json: Vacancy.search(params[:term]), root: false
#       end
#
#     end
#
# Response:
#
# {
#   [
#     {
#       position: "Developer", body: "Some text", location: "Palo Alto, California, United States"
#     },
#     {
#       position: "Designer", body: "Some text", location: "San Carlos, California, United States"
#     }
#   ]
# }
#
#

require 'active_model_serializers'
require 'tire/model/active_model_serializer/serializer_support'

Tire::Results::Collection.send(:include, ActiveModel::ArraySerializerSupport)
Tire::Results::Item.send(:include, ActiveModel::SerializerSupport)
Tire::Results::Item.send(:include, Tire::Model::SerializerSupport)