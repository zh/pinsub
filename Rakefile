require "rubygems"
require 'spec'
require 'spec/rake/spectask'

task :default => :spec

desc "Run all tests"
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.spec_files = FileList['spec/**/*_spec.rb']
  
end

