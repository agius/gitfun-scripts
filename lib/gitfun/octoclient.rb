require 'octokit'

module Gitfun
  class Octoclient < Octokit::Client

    def self.debug_middleware
      Faraday::RackBuilder.new do |builder|
        builder.use Faraday::Request::Retry, exceptions: [Octokit::ServerError]
        builder.use Octokit::Middleware::FollowRedirects
        builder.use Octokit::Response::RaiseError
        builder.use Octokit::Response::FeedParser
        builder.response :logger, nil, { headers: true, bodies: true }
        builder.adapter Faraday.default_adapter
      end
    end

    def self.debug_client(options = {})
      self.new({middleware: stack}.merge(options))
    end

  end
end
