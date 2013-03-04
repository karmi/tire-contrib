# Dynamic Persistence

Adds support for truly dynamic persistence models so that you no longer have to explicitly declare properties.

Very useful if you want to create models on the fly.

## Usage

Require the module in your model file

	require 'tire/model/dynamic_persistence'

Include Persistence and DynamicPersistence

	 class Author

	   include Tire::Model::Persistence
	   include Tire::Model::DynamicPersistence
	 end

Then create your model by passing it a hash of key:value pairs

	 author = Author.new :name => 'Inigo Montoya', 
	                     :books => ['The Pragmatic Swordfighter', 'Revenge: Best Served Cold']

	 author.name 
	 # => 'Inigo Montoya'

