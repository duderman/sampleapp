#!/usr/bin/env ruby

guard :rspec, cmd: 'bundle exec rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})    { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb') { 'spec' }

  # Rails example
  watch(%r{^app/(.+)\.rb$})          { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^spec/support/(.+)\.rb$}) { 'spec' }
end

guard :rubocop, all_on_start: false, cli: %w(--display-cop-names --display-style-guide) do
  watch(/.+\.rb$/)
  watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
  watch('.rubocop_todo.yml')         { '.' }
  watch('config/styles/rubocop.yml') { '.' }
end

guard :bundler do
  require 'guard/bundler'
  require 'guard/bundler/verify'
  helper = Guard::Bundler::Verify.new

  files = ['Gemfile']
  files += Dir['*.gemspec'] if files.any? { |f| helper.uses_gemspec?(f) }

  files.each { |file| watch(helper.real_path(file)) }
end
