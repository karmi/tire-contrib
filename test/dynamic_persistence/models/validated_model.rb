# Example ActiveModel with validations
require 'tire/model/dynamic_persistence'

class ValidatedModel

  include Tire::Model::Persistence
  include Tire::Model::DynamicPersistence

  property :name

  validates_presence_of :name

end
