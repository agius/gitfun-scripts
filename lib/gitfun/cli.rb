require 'commander'

module Gitfun
  class Cli
    include Commander::Methods

    def run
      program :name, 'Gitfun Scripts'
      program :version, Gitfun::VERSION
      program :description, 'Manages test data on gitfun-party Github org'

      command :repos do |c|
        c.syntax = 'gitfun repos'
        c.description = 'Generates a ton of repos in the org'
        c.option '--min MIN', Integer, 'Start at test-repo-MIN (default 1)'
        c.option '--max MAX', Integer, 'End at test-repo-MAX (default 150)'
        c.option '--prefix PREFIX', String, 'Prefix for test repos (default test-repo-)'
        c.action do |args, options|
          options.default min: 1, max: 150, prefix: 'test-repo-'
          generate_repos(opts)
        end
      end

      default_command :help

      run!
    end

    def github_client
      return @github_client if @github_client
      if ENV['GITHUB_TOKEN'].nil? || ENV['GITHUB_TOKEN'].empty?
        raise Gitfun::Error.new('Please set the GITHUB_TOKEN environment variable')
      else
        @github_client = Octoclient.debug_client(access_token: ENV['GITHUB_TOKEN'])
      end
    end

    def generate_repos(opts = {})
      opts[:min].upto(opts[:max]) do |n|
        github_client.post '/repos/gitfun-party/test-repo-template/generate',
          owner: 'gitfun-party',
          name: "#{opts[:prefix]}#{n}",
          description: 'test repo plz ignore',
          accept: 'application/vnd.github.baptiste-preview+json'

        sleep (3..10).to_a.sample
      end
    end
  end
end
