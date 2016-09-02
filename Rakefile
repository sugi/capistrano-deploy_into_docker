require "bundler/gem_tasks"
#require "rspec/core/rake_task"
require 'rake/hooks'
require 'fileutils'

#RSpec::Core::RakeTask.new(:spec)

before :build do
  spec = Bundler.load_gemspec(File.join(File.dirname(__FILE__), 'capistrano-deploy_into_docker.gemspec'))
  FileUtils.chmod(0644, spec.files)
end

#task :default => :spec
task :default => :build
