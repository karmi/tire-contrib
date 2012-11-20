Tire Contributed Components
================================

Extension, additions, other utilities for the [_Tire_](http://karmi.github.com/tire/)
Rubygem for [_ElasticSearch_](http://www.elasticsearch.org/).

Add this to your _Gemfile_:

    gem 'tire-contrib'

Then require the component you want to use in your application initializer. For example:

    require 'tire/rails/logger'

See specific files and folders inside the `lib/tire` folder for instructions and documentation.


### More Like This Queries ###

Adds support for [“more like this”](http://www.elasticsearch.org/guide/reference/query-dsl/mlt-query.html) queries.

### Custom Filters Score ###

Adds support for [“custom filters score”](http://www.elasticsearch.org/guide/reference/query-dsl/custom-filters-score-query.html) queries.

### Rails Logger ###

Adds support for displaying Tire related statistics in the Rails' log.

### Tire test mode ###

For activation test mode you need add line:

    require 'tire/test_helper'

This helper will stop automatic updating tire index which make your test faster. In test where you want to use elasticsearch
you need use special block. It recreate all indexes for clearing any old data and allow automatic index updating. After exiting block,
all indexes will be erased. For example:

    article = Article.create #create article, but doesnt create es index
    Article.tire.search '*'  #return empty list

    Tire.test_mode! do
      article.update_attributes(:title => 'Red socks') #create index in es
      Article.tire.search 'red'                        #will return our article
    end

    Article.tire.search 'red' #will return empty result

Please note!
For saving you development indexes test helper will add `tire_test` to all indexes, so Article will have index with name `tire_test_articles`

-----

[Karel Minarik](http://karmi.cz) and [contributors](http://github.com/karmi/tire-contrib/contributors)
