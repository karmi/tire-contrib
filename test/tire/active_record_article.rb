require 'active_record'
require 'sqlite3'

ActiveRecord::Base.establish_connection( :adapter => 'sqlite3', :database => ":memory:" )
ActiveRecord::Migration.verbose = false
ActiveRecord::Schema.define(:version => 1) do
  create_table :active_record_articles do |t|
    t.string   :title
    t.datetime :created_at, :default => 'NOW()'
  end
end

class ActiveRecordArticle < ActiveRecord::Base

  include Tire::Model::Search
  include Tire::Model::Callbacks

  tire do
    mapping do
      indexes :title,      :type => 'string', :boost => 10, :analyzer => 'snowball'
      indexes :created_at, :type => 'date'
    end
  end

end
