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

After creating a model with dynamic attributes you can add new attributes

A single attribute

     author = Author.new :name => 'Inigo Montoya',
                         :books => ['The Pragmatic Swordfighter', 'Revenge: Best Served Cold']

     author.set_attribute(:rating, 5)
     author.rating
     # => 5

     author[:another_attribute] = 'test'
     author.another_attribute
     # => 'test'

     author.last_attribute = 'something else'
     author.last_attribute
     # => 'something else'

Multiple attributes

     author = Author.new :name => 'Inigo Montoya',
                         :books => ['The Pragmatic Swordfighter', 'Revenge: Best Served Cold']

     author.set_attributes({:home_town => 'Somewhere', :rating => 5})
     author.home_town
     # => 'Somewhere'
     author.rating
     # => 5

     author.update_attributes({:fame => 'lots', :foo => 'bar'})
     author.fame
     # => 'lots'
     author.foo
     # => 'bar'
