require 'spec_helper'

describe GithubConfig do

  before(:all) do 
    @old_config = Rails.application.config.github
    Rails.application.config.github = OpenStruct.new({
      access_token: 'MY_GITHUB_ACCESS_TOKEN',
      webhook_secret: 'MY_GITHUB_WEBHOOK_SECRET'
    }) 
  end

  after(:all) do
    Rails.application.config.github = @old_config
  end

  let(:github_config) { Rails.application.config.github }

  subject { implementor(GithubConfig) }

  it { should respond_to(:github_access_token) }
  it { should respond_to(:github_webhook_secret) }

  describe "#github_access_token" do
    it "returns the configured access token" do
      expect(subject.github_access_token).to be(github_config.access_token)
    end
  end

  describe "#github_webhook_secret" do
    it "returns the configured webhook secret" do
      expect(subject.github_webhook_secret).to be(github_config.webhook_secret)
    end
  end

end