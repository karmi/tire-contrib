# encoding: UTF-8

require 'rake'
require 'fcntl'

require 'tire/importer/importer'
require 'tire/http/clients/curb'
require 'yajl'

namespace :tire do
  namespace :import do

    desc "Import a file into elasticsearch"
    task :file do

      # Check if we have piped input or file as an argument,
      # credit: Brad Greenlee, <http://footle.org/2008/08/21/checking-for-stdin-inruby>
      if STDIN.fcntl(Fcntl::F_GETFL, 0) == 0
        input = STDIN
      else
        input = File.new(ENV['INPUT'], 'r:utf-8') if ENV['INPUT']
      end

      unless input
        puts "[!] ERROR. Please provide input."
        exit 1
      end

      index = ENV['INDEX'] || File.basename(ENV['INPUT'], '.*') rescue nil
      host  = ENV['URL']   || 'http://localhost:9200'

      if index.to_s.empty?
        puts "[!] ERROR. Please provide the index name or filename as input."
        exit 1
      end

      importer = Tire::Importer::Importer.new(input: input, index: index, host: host)
      importer.perform!
    end

    task :fixfile do
      file    = File.new(ENV['INPUT'], 'r:utf-8')

      # Force UTF
      content = file.read.force_encoding('UTF-8')

      # Remove BOM byte sequence
      content.gsub!("\xEF\xBB\xBF".force_encoding('UTF-8'), '')

      file    = File.new(ENV['INPUT'], 'w:utf-8')
      file.write content
      file.close
    end

  end
end
