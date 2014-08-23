require 'spec_helper'

describe Github do

  let(:owner) { 'guidomb' }
  let(:repo)  { 'test-repo' }
  let(:full_repo_name) { "#{owner}/#{repo}" }
  let(:webhook_url) { 'http://reviewer.com/hooks' }
  let(:webhook_secret) { 'foo' }
  let(:client) { instance_double(Octokit::Client) }
  let(:webhook_events) { ['pull_request'] }
  let(:hook_id) { 1 }
  let(:options) do
    {
      events: webhook_events,
      active: true
    }
  end
  let(:github_options) { { webhook_secret: webhook_secret, webhook_url: webhook_url } }

  subject(:github) { Github.new(client, github_options) }
  
  describe ".new" do

    context "when a nil client is provided" do

      subject(:github) { Github.new(nil, github_options) }

      specify { expect { github }.to raise_error(ArgumentError) }

    end

    [:webhook_secret, :webhook_url].each do |option|
    
      context "when a #{option.to_s.gsub('_', ' ')} is not provided" do

        subject(:github) { Github.new(client, github_options.merge(option => nil)) }

        specify { expect { github }.to raise_error(Github::MissingOptionError) }

      end
    
    end

  end

  describe "#create_webhooks!" do

    let(:response) { OpenStruct.new(id: hook_id) }
    let(:config) do 
      {
        url: webhook_url,
        content_type: :json,
        secret: webhook_secret,
        insecure_ssl: false
      } 
    end

    before(:each) do
      expected_args = [full_repo_name, Github::WEBHOOK_NAME, config, options]
      expect(client).to receive(:create_hook).with(*expected_args).and_return(response)
    end

    it "tells the github client to create the hooks" do
      github.create_webhooks!(owner, repo)
    end

    it "responds the created hook ID" do
      expect(github.create_webhooks!(owner, repo)).to eq(hook_id)
    end

  end

  describe "#edit_webhook_url" do
    
    let(:new_url) { 'http://reviewer.wolox.com/hooks' }
    let(:config) do 
      {
        url: new_url,
        content_type: :json,
        secret: webhook_secret,
        insecure_ssl: false
      } 
    end

    before(:each) do
      expected_args = [full_repo_name, hook_id, Github::WEBHOOK_NAME, config, options]
      expect(client).to receive(:edit_hook).with(*expected_args)
    end

    it "tells the github client to edit the hook" do
      github.edit_webhook_url(owner, repo, hook_id, new_url)
    end
  end

  describe "#fetch_webhook_id" do

    let(:response) { [OpenStruct.new(id: hook_id, name: Github::WEBHOOK_NAME)] }

    before(:each) do
      expect(client).to receive(:hooks).with(full_repo_name).and_return(response)
    end

    it "tells the github client to fetch all the hooks for the given repository" do
      github.fetch_webhook_id(owner, repo)
    end

    it "returns the hook id" do
      expect(github.fetch_webhook_id(owner, repo)).to eq(hook_id)
    end

  end

end