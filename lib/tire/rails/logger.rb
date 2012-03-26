# Rails Logger
# ============
#
# Author: Oliver Eilhard <oliver.eilhard@gmail.com>
#
#
# Adds support for displaying Tire related statistics to Rails' log.
#
# Hooks into the ActiveSupport instrumentation framework to publish statistics
# about searches, and display them in the application log.
#
# Usage:
# ------
#
# Require the component in your `application.rb`:
#
#     require 'tire/rails/logger'
#
# You should see an output like this in your application log:
#
#     Started GET "/articles?utf8=%E2%9C%93&q=bull*&commit=search" for 127.0.0.1 at 2011-09-15 19:07:00 +0200
#       Processing by ArticlesController#index as HTML
#       Parameters: {"utf8"=>"✓", "q"=>"bull*", "commit"=>"search"}
#       Search (6.7ms)  {"query":{"query_string":{"query":"bull*"}}}
#       Article Load (0.3ms)  SELECT `articles`.* FROM `articles` WHERE `articles`.`id` IN (104126575)
#     Rendered articles/index.html.erb within layouts/application (13.0ms)
#     Completed 200 OK in 63ms (Views: 53.7ms | ActiveRecord: 1.8ms | Tire: 6.7ms)
#
#
require 'tire/rails/logger/railtie'
