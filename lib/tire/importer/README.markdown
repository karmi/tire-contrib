The source data should have one JSON document per line:

    {"foo" : "bar"}
    {"moo" : "bam"}

Usage:

In your Gemfile:

    source :rubygems

    gem 'tire',         git: 'git://github.com/karmi/tire.git'
    gem 'tire-contrib', git: 'git://github.com/karmi/tire-contrib.git'

In your Rakefile:

    require 'tire'
    require 'tire-contrib'
    require 'tire/importer/tasks'

Then:

    bundle install

    cat path/to/source/files/*.json | \
    time bundle exec rake tire:import:file INDEX=myindex URL=http://localhost:9200
