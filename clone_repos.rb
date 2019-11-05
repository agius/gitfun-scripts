require 'bundler/setup'
require 'octokit'

stack = Faraday::RackBuilder.new do |builder|
  builder.use Faraday::Request::Retry, exceptions: [Octokit::ServerError]
  builder.use Octokit::Middleware::FollowRedirects
  builder.use Octokit::Response::RaiseError
  builder.use Octokit::Response::FeedParser
  builder.response :logger, nil, { headers: true, bodies: true }
  builder.adapter Faraday.default_adapter
end
Octokit.middleware = stack

client = Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])

2.upto(150) do |n|
  client.post '/repos/gitfun-party/test-repo-template/generate',
    owner: 'gitfun-party',
    name: "test-repo-#{n}",
    description: 'test repo plz ignore',
    accept: 'application/vnd.github.baptiste-preview+json'

  sleep (3..10).to_a.sample
end
