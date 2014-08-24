require 'spec_helper'

describe PullRequestEventManager::OpenedPullRequest do

  let(:payload) { load_json_fixture('opened_pull_request') }
  let(:repository) { payload['repository']['full_name'] }
  let(:number) { payload['number'] }
  subject(:manager) { PullRequestEventManager::OpenedPullRequest.new(payload) }

  describe "#handle_event" do

    it "creates a new pull request object" do
      expect { manager.handle_event }.to change { PullRequest.count }.by(1)
    end

    context "when a pull request already exists with the given number" do

      before(:each) { create(:pull_request, number: number, repository: repository) }

      specify { expect { manager.handle_event }.to(
        raise_error(PullRequestEventManager::PullRequestAlreadyOpenedError)) }

    end

  end

end