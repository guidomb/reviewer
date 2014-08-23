require 'octokit'
require 'dotenv/tasks'

namespace :github do
  include Rails.application.routes.url_helpers

  desc 'Creates webhooks for a repo'
  task :create_webhook, [:owner, :repo] => :environment do |t, args|
    hook_id = github.create_webhooks!(args[:owner], args[:repo])
    puts "The created hook ID is #{hook_id}."
  end

  desc 'Edit webhook URL'
  task :edit_webhook_url, [:owner,:repo,:id,:url] => :environment do |t, args|
    github.edit_webhook_url(args[:owner], args[:repo], args[:id], args[:url])
  end

  def github
    @github ||= Github.new(client, webhook_secret: webhook_secret, webhook_url: webhook_url)
  end

  def client
    Octokit::Client.new(access_token: access_token)
  end

  def access_token
    ENV['GITHUB_ACCESS_TOKEN']
  end

  def webhook_secret
    ENV['GITHUB_WEBHOOK_SECRET']
  end

  def webhook_url
    github_webhooks_url(host: ENV['APPLICATION_HOST'])
  end

end