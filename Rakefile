#!/usr/bin/env rake

task :environment do
  require './app'
end

Dir[File.dirname(__FILE__) + '/lib/tasks/*.rb'].sort.each do |path|
  require path
end
