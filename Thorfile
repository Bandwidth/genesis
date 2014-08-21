$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'bundler'
require 'thor/rake_compat'

class Default < Thor
  include Thor::RakeCompat
  Bundler::GemHelper.install_tasks

  desc 'build', "Build #{@gem_name} into the pkg directory"
  def build
    Rake::Task['build'].execute
  end

  desc 'install', "Build and install #{@gem_name} into system gems"
  def install
    Rake::Task['install'].execute
  end

  desc 'release', "Create tag #{@gem_tag} and build and push #{@gem_name}"
  def release
    Rake::Task['release'].execute
  end

  desc 'rubocop', 'Run Rubocop on all Ruby files'
  def rubocop
    say 'Performing linting and style checking with rubocop...', :white
    success = system 'rubocop'
    exit(!success) unless success
  end

  desc 'check', 'Lint, style, and test.'
  def check
    invoke :rubocop
  end

  def initialize(*args)
    super
    @gem_name = "genesis-#{Genesis::VERSION}.gem"
    @gem_tag = "v#{Genesis::VERSION}"
  end
end
