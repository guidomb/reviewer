require 'rails_helper'
require 'support/github_webhooks_helper'

describe GithubWebhooksController, type: :controller do
  include GithubWebhooksHelper

  describe "POST create" do
    
    context "when a 'pull_request' event is posted" do
      
      context "when a supported action is posted" do

        before(:each) do
          payload = load_json_fixture('opened_pull_request')
          action = payload['action']
          post_hook_event(:create, 'pull_request', payload)
        end

        it { expect(response).to have_http_status 200 }

      end

      context "when an invalid action is posted" do

        before(:each) do
          action = 'foo'
          payload = load_json_fixture('opened_pull_request').merge(action: action)
          post_hook_event(:create, 'pull_request', payload)
        end

        it { expect(response).to have_http_status 400 }

      end

    end

  end

end