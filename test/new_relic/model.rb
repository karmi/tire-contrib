class TestModel

  include Tire::Model::Persistence
  include Tire::Model::NewRelic

  property :title

end
