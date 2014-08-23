require 'spec_helper'

describe Github do

  let(:webhook_url) { 'http://reviewer.com/hooks' }
  let(:webhook_secret) { 'foo' }
  let(:client) { instance_double(Octokit::Client) }

  subject(:github) { Github.new(client, webhook_secret: webhook_secret, webhook_url: webhook_url) }

  describe "#create_webhooks!" do

    let(:owner) { 'guidomb' }
    let(:repo)  { 'test-repo' }
    let(:webhook_events) { ['pull_request'] }
    let(:options) do
      {
        events: webhook_events,
        active: true
      }
    end
    let(:config) do 
      {
        url: webhook_url,
        content_type: :json,
        secret: webhook_secret,
        insecure_ssl: true
      } 
    end

    it "tells the github client to create the hooks" do
      full_repo_name = "#{owner}/#{repo}"
      expected_args = [full_repo_name, Github::WEBHOOK_NAME, config, options]
      expect(client).to receive(:create_hook).with(*expected_args)
      github.create_webhooks!(owner, repo)
    end

  end

end