require 'gitfun/version'
require 'gitfun/octoclient'
require 'gitfun/cli'

module Gitfun
  class Error < StandardError; end

  module_function

  def run!
    Cli.new.run
  end
end
