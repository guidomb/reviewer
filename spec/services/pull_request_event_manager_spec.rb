require 'rails_helper'

describe PullRequestEventManager do
  
  subject(:manager) { PullRequestEventManager.new }

  describe "#valid_action?" do

    PullRequestEventManager::VALID_ACTIONS.each do |action|

      context "when is called with action '#{action}'" do

        it { expect(manager.valid_action?(action)).to be_truthy }

      end

    end

    context "when is called with an invalid action" do

      it { expect(manager.valid_action?("foo")).to be_falsy }

    end

  end

  describe "#supported_action?" do

    PullRequestEventManager::SUPPORTED_ACTIONS.each do |action|

      context "when is called with action '#{action}'" do

        it { expect(manager.supported_action?(action)).to be_truthy }

      end

    end

    PullRequestEventManager::UNSUPPORTED_ACTIONS.each do |action|

      context "when is called with action '#{action}'" do

        it { expect(manager.supported_action?(action)).to be_falsy}

      end

    end

  end

  describe "#handler_for_pull_request_event" do

    let(:payload) do 
      load_json_fixture('opened_pull_request').merge(action: action)
    end

    PullRequestEventManager::SUPPORTED_ACTIONS.each do |supported_action|
      context "when is called with action '#{supported_action}'" do

        let(:action) { supported_action }
        let(:event_handler) { "PullRequestEventManager::#{action.capitalize}PullRequest".constantize }


        it { expect(manager.handler_for_pull_request_event(action, payload)).to be_an event_handler }

      end
    end

    PullRequestEventManager::UNSUPPORTED_ACTIONS.each do |unsupported_action|
      context "when is called with action '#{unsupported_action}'" do

        let(:action) { unsupported_action }

        it { expect { manager.handler_for_pull_request_event(action, payload) }.to(
          raise_error(PullRequestEventManager::UnsupportedActionError)) }

      end
    end

    context "when is called with an invalid action" do

      let(:action) { 'foo' }

      it { expect { manager.handler_for_pull_request_event(action, payload) }.to(
        raise_error(PullRequestEventManager::InvalidActionError)) }

    end

  end

end