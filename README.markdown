Tire Contributed Components
================================

Extension, additions, other utilities for the [_Tire_](http://karmi.github.com/tire/)
Rubygem for [_ElasticSearch_](http://www.elasticsearch.org/).

Add this to your _Gemfile_:

    gem 'tire-contrib'

Then require the component you want to use in your application initializer. For example:

    require 'tire/rails/logger'

See specific files and folders inside the `lib/tire` folder for instructions and documentation.


### Dynamic Persistence ###

Adds support for dynamic attributes when using Tire::Model::Persistence so that model properties no longer need to be declared explicitly. [More info](lib/tire/model/dynamic_persistence).

### More Like This Queries ###

Adds support for [“more like this”](http://www.elasticsearch.org/guide/reference/query-dsl/mlt-query.html) queries.

### Fuzzy Like This Queries ###

Adds support for [“fuzzy like this”](http://www.elasticsearch.org/guide/reference/query-dsl/flt-query.html) queries.

### Custom Filters Score ###

Adds support for [“custom filters score”](http://www.elasticsearch.org/guide/reference/query-dsl/custom-filters-score-query.html) queries.

### Constant Score Query ###

Adds support for [“constant score query”](http://www.elasticsearch.org/guide/reference/query-dsl/constant-score-query.html) queries.

### Rails Logger ###

Adds support for displaying Tire related statistics in the Rails' log.

### Namespace ###

Adds support for namespace all Index's of an Application

-----

[Karel Minarik](http://karmi.cz) and [contributors](http://github.com/karmi/tire-contrib/contributors)
